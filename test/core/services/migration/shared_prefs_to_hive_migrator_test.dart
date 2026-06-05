import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/constants/hive_box_keys.dart';
import 'package:habit_it/core/services/migration/shared_prefs_to_hive_migrator.dart';
import 'package:habit_it/data/datasources/hive/hive_app_source.dart';
import 'package:habit_it/data/datasources/hive/hive_habit_source.dart';
import 'package:habit_it/data/datasources/hive/hive_user_source.dart';
import 'package:habit_it/data/entities/month_key.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FND-002 AC#3 + AC#5 — migrator regression test.
///
/// Fixture: two months (2026-5 and 2026-6) with two habits each + day/month
/// init flags + user + app records. Asserts:
///   - all Hive boxes carry the new state,
///   - legacy SP keys are RETAINED (post C-1 fix — legacy screens still read
///     from SP during this slice; see migrator class docstring),
///   - `migratedV1` flips to true,
///   - second invocation returns `MigrationReport.skipped`,
///   - PO G-002: habit with empty `repeatDays` is counted in the report.
void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_migrator_test_');
    Hive.init(tempDir.path);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  setUp(() async {
    // Fresh boxes for each test.
    for (final name in [
      HiveBoxKeys.app,
      HiveBoxKeys.user,
      HiveBoxKeys.habits,
    ]) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).clear();
      } else {
        await Hive.openBox(name);
        await Hive.box(name).clear();
      }
    }
  });

  test('migrates two months of legacy SharedPreferences habits into Hive', () async {
    final spFixture = <String, Object>{
      'APP/APP': jsonEncode({
        'init': true,
        'initDate': '2026-5-1',
        'lastDate': '2026-6-5',
      }),
      'APP/USER': jsonEncode({
        'id': 'user-1',
        'username': 'tester',
        'gender': 'Female',
        'password': '12345',
        'isRegistered': true,
        'isAuthenticated': false,
        'isPINAuthenticated': true,
        'isBiometricAuthenticated': false,
      }),
      'APP/HABIT/MONTH/2026-5': jsonEncode([
        {
          'id': 'h1',
          'name': 'Drink water',
          'repeatDays': ['Monday', 'Friday'],
          'daysStates': {'2': 1, '5': 2},
          'createdDate': '2026-05-01T00:00:00.000',
        },
        {
          'id': 'h2',
          'name': 'Walk',
          'repeatDays': [], // PO G-002 — empty repeatDays
          'daysStates': {'2': 0},
          'createdDate': '2026-05-01T00:00:00.000',
        },
      ]),
      'APP/HABIT/MONTH/INIT2026-5': jsonEncode(true),
      'APP/HABIT/INIT/2026-5-2': jsonEncode(true),
      'APP/HABIT/MONTH/2026-6': jsonEncode([
        {
          'id': 'h3',
          'name': 'Meditate',
          'repeatDays': ['Tuesday', 'Thursday'],
          'daysStates': {'3': 1},
          'createdDate': '2026-06-01T00:00:00.000',
        },
        {
          'id': 'h4',
          'name': 'Read',
          'repeatDays': ['Wednesday'],
          'daysStates': {'4': 'DONE'}, // modern wire format
          'createdDate': '2026-06-01T00:00:00.000',
        },
      ]),
      'APP/HABIT/MONTH/INIT2026-6': jsonEncode(true),
      'APP/HABIT/INIT/2026-6-4': jsonEncode(true),
    };

    SharedPreferences.setMockInitialValues(spFixture);
    final prefs = await SharedPreferences.getInstance();

    final migrator = SharedPrefsToHiveMigrator(
      prefs: prefs,
      hiveApp: HiveAppSource(),
      hiveUser: HiveUserSource(),
      hiveHabit: HiveHabitSource(),
    );

    final report = await migrator.runIfNeeded();

    expect(report.failed, isFalse);
    expect(report.skipped, isFalse);
    expect(report.appMigrated, isTrue);
    expect(report.userMigrated, isTrue);
    expect(report.monthsMigrated, containsAll(['2026-5', '2026-6']));
    expect(report.daysMigrated, containsAll(['2026-5-2', '2026-6-4']));
    expect(report.coercedEmptyRepeatDays, 1,
        reason: 'PO G-002 — empty repeatDays should be counted');
    expect(report.legacyKeysCleared, 0,
        reason:
            'C-1 fix: legacy SP keys are intentionally retained so legacy '
            'screens (Splash/Signup/Habit/Profile) keep reading them until '
            'the legacy datasources are removed in a subsequent sprint');

    // App + user in Hive.
    final app = await HiveAppSource().read();
    expect(app.migratedV1, isTrue);
    expect(app.initDate, '2026-5-1');

    final user = await HiveUserSource().read();
    expect(user.username, 'tester');
    expect(user.password, '12345',
        reason: 'legacy plain-text PIN stays until AuthMigrator hashes it');

    // Habits in Hive.
    final habitsMay = await HiveHabitSource().getMonth(const MonthKey(2026, 5));
    expect(habitsMay, hasLength(2));
    expect(habitsMay[0].name, 'Drink water');
    expect(habitsMay[0].repeatDays, contains('Monday'));

    final habitsJune = await HiveHabitSource().getMonth(const MonthKey(2026, 6));
    expect(habitsJune, hasLength(2));
    expect(habitsJune[0].name, 'Meditate');

    // C-1 fix: legacy SharedPreferences keys MUST be retained.
    // Legacy screens (Splash, AppShell, Signup, HabitScreen, ProfileScreen)
    // still read these keys via the un-rewired *LocalDataSourceImpl
    // registrations in `lib/core/di/injection.dart:75-90`. Clearing them
    // here would cause SplashScreen._initCurrentUserData() to read null,
    // route to onboarding, and orphan every upgraded user's data.
    expect(prefs.getString('APP/APP'), isNotNull,
        reason: 'C-1 — legacy app key must survive migration');
    expect(prefs.getString('APP/USER'), isNotNull,
        reason: 'C-1 — legacy user key must survive migration');
    expect(prefs.getString('APP/HABIT/MONTH/2026-5'), isNotNull,
        reason: 'C-1 — legacy habit-month key must survive migration');
    expect(prefs.getString('APP/HABIT/MONTH/INIT2026-5'), isNotNull,
        reason: 'C-1 — legacy month-init key must survive migration');
    expect(prefs.getString('APP/HABIT/INIT/2026-5-2'), isNotNull,
        reason: 'C-1 — legacy day-init key must survive migration');
  });

  test('second invocation returns skipped without touching data', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Seed Hive app with migratedV1=true to simulate a prior successful run.
    final appSrc = HiveAppSource();
    final app = await appSrc.read();
    await appSrc.write(app.copyWith(migratedV1: true));

    final migrator = SharedPrefsToHiveMigrator(
      prefs: prefs,
      hiveApp: appSrc,
      hiveUser: HiveUserSource(),
      hiveHabit: HiveHabitSource(),
    );

    final report = await migrator.runIfNeeded();
    expect(report.skipped, isTrue);
    expect(report.appMigrated, isFalse);
    expect(report.userMigrated, isFalse);
  });
}

