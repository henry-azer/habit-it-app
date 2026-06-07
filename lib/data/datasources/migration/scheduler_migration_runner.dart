import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../core/utils/app_local_storage_strings.dart';
import '../../../core/utils/date_util.dart';
import '../../entities/habit.dart';
import '../../entities/recurrence.dart';
import '../../entities/scheduled_item.dart';
import '../../enums/habit_state.dart';
import '../scheduler/scheduled_item_local_datasource.dart';

// Note on item IDs in migration: the new id is deterministically derived from
// the legacy `Habit.id` of the first occurrence in ASCII-sorted month-key
// order. This preserves byte-level idempotency across re-runs — the architect
// brief calls for "running migration twice produces an identical
// APP/SCHEDULER/ITEMS payload" (`docs/scheduler/architecture.md` §6.4); using
// the legacy id is the only way to honor that without keeping the
// `NumbersUtil.getRandomId()` call deterministic. New (non-migrated) items
// continue to use `NumbersUtil.getRandomId()` at creation time.

/// One-shot migration from the legacy `APP/HABIT/MONTH/*` blobs into the
/// unified `APP/SCHEDULER/ITEMS` store. Runs once, is idempotent, never
/// throws, never deletes legacy data. See
/// `docs/scheduler/architecture.md` §6.
class SchedulerMigrationRunner {
  final IStorageManager storageManager;
  final ScheduledItemLocalDataSource scheduledItemLocalDataSource;
  final SharedPreferences sharedPreferences;

  SchedulerMigrationRunner({
    required this.storageManager,
    required this.scheduledItemLocalDataSource,
    required this.sharedPreferences,
  });

  Future<MigrationSummary> run() async {
    final alreadyComplete =
        await storageManager.getValue<bool>(
          AppLocalStorageKeys.schedulerMigrationV1Complete,
        ) ??
        false;
    if (alreadyComplete) {
      return MigrationSummary.alreadyComplete();
    }

    final legacy = await snapshotLegacy();
    if (legacy.isEmpty) {
      await storageManager.setValue(
        AppLocalStorageKeys.schedulerMigrationV1Complete,
        true,
      );
      // ignore: avoid_print
      print('[SchedulerMigration] fresh install — flag set');
      return MigrationSummary.freshInstall();
    }

    // Always back up first.
    await storageManager.setValue(
      AppLocalStorageKeys.schedulerMigrationV1Backup,
      legacy,
    );

    final buildResult = buildItems(legacy);

    // Persist via the datasource so the same single-flight write path is used.
    for (final item in buildResult.items) {
      await scheduledItemLocalDataSource.add(item);
    }

    await storageManager.setValue(
      AppLocalStorageKeys.schedulerMigrationV1Complete,
      true,
    );

    final summary = MigrationSummary(
      wasFreshInstall: false,
      wasAlreadyComplete: false,
      legacyKeysFound: legacy.length,
      legacyHabitsScanned: buildResult.scanned,
      scheduledItemsCreated: buildResult.items.length,
      completionEntriesCopied: buildResult.copied,
      skippedNoRepeatDays: buildResult.skippedNoRepeatDays,
      skippedMalformed: buildResult.skippedMalformed,
      completedAt: DateTime.now(),
    );

    // §12.5 — break skipped total down by reason in the summary print.
    // ignore: avoid_print
    print(
      '[SchedulerMigration] complete: ${summary.scheduledItemsCreated} items, '
      '${summary.completionEntriesCopied} entries, '
      'skipped: ${summary.skippedRecords} '
      '(${summary.skippedNoRepeatDays} no repeatDays, '
      '${summary.skippedMalformed} malformed)',
    );

    return summary;
  }

  /// Visible for testing. Reads every `APP/HABIT/*` key directly from
  /// [SharedPreferences] (the [IStorageManager] does not expose `getKeys`).
  /// Values that fail to JSON-decode are stored as the raw string so the
  /// backup blob is still total.
  Future<Map<String, dynamic>> snapshotLegacy() async {
    final allKeys = sharedPreferences.getKeys().toList()..sort();
    final legacy = <String, dynamic>{};
    for (final key in allKeys) {
      if (!key.startsWith('APP/HABIT/')) continue;
      final raw = sharedPreferences.getString(key);
      if (raw == null) continue;
      try {
        legacy[key] = jsonDecode(raw);
      } catch (_) {
        legacy[key] = raw;
      }
    }
    return legacy;
  }

  /// Visible for testing. Pure transform of legacy blob -> deduped item list
  /// + summary counters. Iteration is deterministic (ASCII-sorted month keys)
  /// so idempotency holds at the byte-comparison level.
  BuildResult buildItems(Map<String, dynamic> legacy) {
    // Data keys only: `APP/HABIT/MONTH/<year>-<month>`. The init flags
    // (`APP/HABIT/MONTH/INIT<...>` and `APP/HABIT/INIT/<...>`) are filtered.
    final monthKeys =
        legacy.keys
            .where(
              (k) =>
                  k.startsWith(AppLocalStorageKeys.habitMonth) &&
                  !k.startsWith(AppLocalStorageKeys.habitMonthInit),
            )
            .toList()
          ..sort();

    final byDedupKey = <String, ScheduledItem>{};
    int scanned = 0;
    int skippedNoRepeatDays = 0;
    int skippedMalformed = 0;
    int copied = 0;

    for (final key in monthKeys) {
      final monthString = key.substring(AppLocalStorageKeys.habitMonth.length);
      final parts = monthString.split('-');
      if (parts.length < 2) {
        skippedMalformed++;
        continue;
      }
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      if (year == null || month == null) {
        skippedMalformed++;
        continue;
      }

      final raw = legacy[key];
      if (raw is! List) {
        // A corrupted (non-list) month value: count once and move on.
        skippedMalformed++;
        continue;
      }

      for (final recordRaw in raw) {
        scanned++;
        try {
          final legacyHabit = Habit.fromJson(
            Map<String, dynamic>.from(recordRaw as Map),
          );
          if (legacyHabit.repeatDays.isEmpty) {
            skippedNoRepeatDays++;
            continue;
          }
          final dedupKey =
              '${legacyHabit.name}::${legacyHabit.createdDate.toIso8601String()}';
          ScheduledItem target =
              byDedupKey[dedupKey] ??
              ScheduledItem(
                // Reuse the legacy id so a re-run produces a byte-identical
                // blob (idempotency AC in tech story 1.2).
                id: legacyHabit.id,
                name: legacyHabit.name,
                createdDate: legacyHabit.createdDate,
                recurrence: Recurrence.weekly(
                  legacyHabit.repeatDays,
                  legacyHabit.createdDate,
                ),
                completionLog: <String, HabitState>{},
                carryOverEnabled: false,
              );

          legacyHabit.daysStates.forEach((day, state) {
            final iso = DateUtil.isoDate(DateTime(year, month, day));
            target.completionLog[iso] = state;
            copied++;
          });
          byDedupKey[dedupKey] = target;
        } catch (_) {
          skippedMalformed++;
        }
      }
    }

    return BuildResult(
      items: byDedupKey.values.toList(),
      scanned: scanned,
      skippedNoRepeatDays: skippedNoRepeatDays,
      skippedMalformed: skippedMalformed,
      copied: copied,
    );
  }
}

/// Summary of one run. The print line in [SchedulerMigrationRunner.run]
/// formats from this struct; tests assert against its fields directly.
class MigrationSummary {
  final bool wasFreshInstall;
  final bool wasAlreadyComplete;
  final int legacyKeysFound;
  final int legacyHabitsScanned;
  final int scheduledItemsCreated;
  final int completionEntriesCopied;
  final int skippedNoRepeatDays;
  final int skippedMalformed;
  final DateTime completedAt;

  MigrationSummary({
    required this.wasFreshInstall,
    required this.wasAlreadyComplete,
    required this.legacyKeysFound,
    required this.legacyHabitsScanned,
    required this.scheduledItemsCreated,
    required this.completionEntriesCopied,
    required this.skippedNoRepeatDays,
    required this.skippedMalformed,
    required this.completedAt,
  });

  int get skippedRecords => skippedNoRepeatDays + skippedMalformed;

  factory MigrationSummary.freshInstall() => MigrationSummary(
    wasFreshInstall: true,
    wasAlreadyComplete: false,
    legacyKeysFound: 0,
    legacyHabitsScanned: 0,
    scheduledItemsCreated: 0,
    completionEntriesCopied: 0,
    skippedNoRepeatDays: 0,
    skippedMalformed: 0,
    completedAt: DateTime.now(),
  );

  factory MigrationSummary.alreadyComplete() => MigrationSummary(
    wasFreshInstall: false,
    wasAlreadyComplete: true,
    legacyKeysFound: 0,
    legacyHabitsScanned: 0,
    scheduledItemsCreated: 0,
    completionEntriesCopied: 0,
    skippedNoRepeatDays: 0,
    skippedMalformed: 0,
    completedAt: DateTime.now(),
  );
}

class BuildResult {
  final List<ScheduledItem> items;
  final int scanned;
  final int skippedNoRepeatDays;
  final int skippedMalformed;
  final int copied;

  BuildResult({
    required this.items,
    required this.scanned,
    required this.skippedNoRepeatDays,
    required this.skippedMalformed,
    required this.copied,
  });
}
