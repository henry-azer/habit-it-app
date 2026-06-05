import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/datasources/hive/hive_app_source.dart';
import '../../../data/datasources/hive/hive_habit_source.dart';
import '../../../data/datasources/hive/hive_user_source.dart';
import '../../../data/entities/app_entity.dart';
import '../../../data/entities/habit.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/entities/user_entity.dart';
import '../../constants/app_constants.dart';
import 'migration_report.dart';

/// One-shot SharedPreferences → Hive migrator.
///
/// Runs on first launch after upgrade. Detects legacy keys, writes them to
/// Hive, and persists `migratedV1=true` in the app entity so the migrator
/// never runs twice.
///
/// **Legacy SharedPreferences keys are intentionally retained** after the
/// Hive write completes. The live legacy screens (Splash, AppShell, Signup,
/// HabitScreen, ProfileScreen) still read directly from SP via the
/// un-rewired `AppLocalDataSourceImpl` / `UserLocalDataSourceImpl` /
/// `HabitLocalDataSourceImpl` (see `lib/core/di/injection.dart:75-90`).
/// Clearing those keys here would orphan all migrated data: the legacy
/// SplashScreen would read `null` from SP, see `isRegistered = false`, and
/// route every upgraded user back through onboarding. Hive becomes the
/// source of truth for new code; SP remains the read-through truth for
/// legacy screens during this slice.
///
/// TODO(post-AUTH/SET): drop legacy SP keys when legacy *LocalDataSource*
/// impls are removed and all consumers read through the new repositories.
///
/// **Failure handling:** If anything throws, the migrator does NOT flip
/// `migratedV1`. The next launch retries idempotently — Hive writes
/// overwrite, so partial progress is safe.
class SharedPrefsToHiveMigrator {
  SharedPrefsToHiveMigrator({
    required this.prefs,
    required this.hiveApp,
    required this.hiveUser,
    required this.hiveHabit,
  });

  final SharedPreferences prefs;
  final HiveAppSource hiveApp;
  final HiveUserSource hiveUser;
  final HiveHabitSource hiveHabit;

  // Regex to match legacy keys. See TECHNICAL_STORIES.md §TS-FND-002 edge cases.
  static final RegExp _monthRegex =
      RegExp(r'^APP/HABIT/MONTH/(\d{4}-\d{1,2})$');
  static final RegExp _monthInitRegex =
      RegExp(r'^APP/HABIT/MONTH/INIT(\d{4}-\d{1,2})$');
  static final RegExp _dayInitRegex =
      RegExp(r'^APP/HABIT/INIT/(\d{4}-\d{1,2}-\d{1,2})$');

  /// Idempotent entry point. Safe to call on every cold start.
  Future<MigrationReport> runIfNeeded() async {
    final current = await hiveApp.read();
    if (current.migratedV1) return MigrationReport.skipped();

    final report = MigrationReport.empty();
    try {
      await _migrateApp(report, current);
      await _migrateUser(report);
      await _migrateHabits(report);
      // Flip the flag so the migrator never runs twice. Legacy SP keys are
      // intentionally retained — see class docstring for rationale and the
      // TODO(post-AUTH/SET) marker that tracks the cleanup sprint.
      final updated = (await hiveApp.read()).copyWith(migratedV1: true);
      await hiveApp.write(updated);
      report.legacyKeysCleared = 0;
      return report.markComplete();
    } catch (e, st) {
      return report.markFailed(e, st);
    }
  }

  Future<void> _migrateApp(MigrationReport report, AppEntity current) async {
    final raw = prefs.getString(AppConstants.legacyAppKey);
    if (raw == null) {
      // Clean install — set migratedV1 and bail.
      await hiveApp.write(current.copyWith(migratedV1: false));
      return;
    }
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      await hiveApp.write(AppEntity(
        init: map['init'] as bool? ?? false,
        initDate: map['initDate'] as String? ?? '',
        lastDate: map['lastDate'] as String? ?? '',
        migratedV1: false,
      ));
      report.appMigrated = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[migrator] failed to parse legacy APP/APP: $e');
      }
    }
  }

  Future<void> _migrateUser(MigrationReport report) async {
    final raw = prefs.getString(AppConstants.legacyUserKey);
    if (raw == null) return;
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      // Legacy `password` is a plain-text PIN; the AuthMigrator (AUTH-001) will
      // upgrade it to PBKDF2-SHA256. Until then keep it on the user entity.
      final legacyPassword = map['password'] as String?;
      await hiveUser.write(UserEntity(
        id: map['id'] as String? ?? '',
        username: map['username'] as String? ?? '',
        gender: map['gender'] as String? ?? '',
        password: (legacyPassword == null || legacyPassword.isEmpty)
            ? null
            : legacyPassword,
        isRegistered: map['isRegistered'] as bool? ?? false,
        isAuthenticated: map['isAuthenticated'] as bool? ?? false,
        isPINAuthenticated: map['isPINAuthenticated'] as bool? ?? false,
        isBiometricAuthenticated:
            map['isBiometricAuthenticated'] as bool? ?? false,
      ));
      report.userMigrated = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[migrator] failed to parse legacy APP/USER: $e');
      }
    }
  }

  Future<void> _migrateHabits(MigrationReport report) async {
    final keys = prefs.getKeys();
    for (final key in keys) {
      final monthMatch = _monthRegex.firstMatch(key);
      if (monthMatch != null) {
        await _migrateMonthHabits(key, monthMatch.group(1)!, report);
        continue;
      }
      final monthInitMatch = _monthInitRegex.firstMatch(key);
      if (monthInitMatch != null) {
        final monthKey = MonthKey.parse(monthInitMatch.group(1)!);
        await hiveHabit.setMonthInit(monthKey, _readBool(key) ?? false);
        continue;
      }
      final dayInitMatch = _dayInitRegex.firstMatch(key);
      if (dayInitMatch != null) {
        final parts = dayInitMatch.group(1)!.split('-');
        final d = DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        await hiveHabit.setDayInit(d, _readBool(key) ?? false);
        report.daysMigrated = List.of(report.daysMigrated)..add(dayInitMatch.group(1)!);
      }
    }
  }

  Future<void> _migrateMonthHabits(
      String key, String monthString, MigrationReport report) async {
    final raw = prefs.getString(key);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;
      final List<Habit> habits = [];
      for (final entry in decoded) {
        try {
          final habit =
              Habit.fromJson(Map<String, dynamic>.from(entry as Map));
          // PO G-002 — log + count empty repeatDays.
          if (habit.repeatDays.isEmpty) {
            report.coercedEmptyRepeatDays++;
            if (kDebugMode) {
              debugPrint(
                  '[migrator] habit ${habit.id} has empty repeatDays — '
                  'coerced to HabitSchedule.none() (PO G-002)');
            }
          }
          habits.add(habit);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[migrator] failed to parse habit in $key: $e');
          }
        }
      }
      final monthKey = MonthKey.parse(monthString);
      await hiveHabit.putMonth(monthKey, habits);
      report.monthsMigrated = List.of(report.monthsMigrated)..add(monthString);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[migrator] failed to migrate $key: $e');
      }
    }
  }

  bool? _readBool(String key) {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is bool ? decoded : null;
    } catch (_) {
      return null;
    }
  }

}
