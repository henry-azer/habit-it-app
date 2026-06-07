import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/datasources/migration/scheduler_migration_runner.dart';
import 'package:habit_it/data/datasources/scheduler/scheduled_item_local_datasource.dart';
import 'package:habit_it/data/entities/recurrence.dart';
import 'package:habit_it/data/entities/scheduled_item.dart';
import 'package:habit_it/data/enums/habit_state.dart';
import 'package:habit_it/data/enums/recurrence_kind.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../_fakes/fake_storage_manager.dart';
import '../../../_fixtures/legacy_habit_fixtures.dart';

Future<SchedulerMigrationRunner> _buildRunner({
  Map<String, String> legacy = const {},
}) async {
  // `setMockInitialValues` provides a fake [SharedPreferences] that the
  // migration runner can read via `getKeys` and `getString`.
  SharedPreferences.setMockInitialValues(legacy);
  final prefs = await SharedPreferences.getInstance();

  final storage = FakeStorageManager();
  final ds = ScheduledItemLocalDataSourceImpl(storageManager: storage);
  final runner = SchedulerMigrationRunner(
    storageManager: storage,
    scheduledItemLocalDataSource: ds,
    sharedPreferences: prefs,
  );

  // Expose dependencies through the runner — the test reaches into them via
  // helpers below.
  _testDeps[runner] = _Deps(storage: storage, datasource: ds, prefs: prefs);
  return runner;
}

class _Deps {
  final FakeStorageManager storage;
  final ScheduledItemLocalDataSourceImpl datasource;
  final SharedPreferences prefs;
  _Deps({required this.storage, required this.datasource, required this.prefs});
}

final Map<SchedulerMigrationRunner, _Deps> _testDeps =
    <SchedulerMigrationRunner, _Deps>{};

_Deps _depsOf(SchedulerMigrationRunner r) => _testDeps[r]!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fresh install — no legacy data — sets V1_COMPLETE only', () async {
    final runner = await _buildRunner();
    final summary = await runner.run();

    expect(summary.wasFreshInstall, isTrue);
    expect(summary.scheduledItemsCreated, 0);

    final deps = _depsOf(runner);
    expect(
      await deps.storage.getValue<bool>(
        AppLocalStorageKeys.schedulerMigrationV1Complete,
      ),
      isTrue,
    );
    expect(
      deps.storage.store.containsKey(AppLocalStorageKeys.schedulerItems),
      isFalse,
    );
  });

  test('idempotent: second run after V1_COMPLETE is a no-op', () async {
    final runner = await _buildRunner();
    await runner.run();
    final summary = await runner.run();
    expect(summary.wasAlreadyComplete, isTrue);
    expect(summary.scheduledItemsCreated, 0);
  });

  test(
    'three months same habit merges (realistic moveMonthHabits) — §12.8',
    () async {
      // The fixture mirrors the real `moveMonthHabits` output: distinct
      // legacy `id` and `createdDate` per month-copy. The §12.8 dedup key
      // (name + sorted weekday set) collapses them; the oldest-month copy
      // wins on `id`, `createdDate`, and `recurrence.weekdays`.
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner.run();

      final deps = _depsOf(runner);
      final items = await deps.datasource.getAll();
      expect(items.length, 2);

      final walk = items.firstWhere((it) => it.name == 'Walk');
      // Apr is the oldest month (ASCII-sorted first) — its id, createdDate,
      // and repeatDays win.
      expect(walk.id, 'WALK0001');
      expect(walk.createdDate, DateTime(2026, 4, 1));
      expect(walk.recurrence.kind, RecurrenceKind.weekly);
      expect(walk.recurrence.weekdays, <String>[
        'Friday',
        'Monday',
        'Wednesday',
      ]);
      expect(walk.recurrence.startDate, DateTime(2026, 4, 1));
      expect(walk.carryOverEnabled, isFalse);

      // Apr 1 (DONE), Apr 3 (NOT_DONE), Apr 6 (DONE) +
      // May 4 (DONE), May 6 (SUSPENDED), May 8 (DONE) +
      // Jun 1 (NOT_DONE), Jun 15 (DONE)
      expect(walk.completionLog, {
        '2026-04-01': HabitState.DONE,
        '2026-04-03': HabitState.NOT_DONE,
        '2026-04-06': HabitState.DONE,
        '2026-05-04': HabitState.DONE,
        '2026-05-06': HabitState.SUSPENDED,
        '2026-05-08': HabitState.DONE,
        '2026-06-01': HabitState.NOT_DONE,
        '2026-06-15': HabitState.DONE,
      });

      final stretch = items.firstWhere((it) => it.name == 'Stretch');
      // May is the oldest month Stretch appears in.
      expect(stretch.id, 'STRETCH1');
      expect(stretch.createdDate, DateTime(2026, 5, 10));
      expect(stretch.recurrence.weekdays, <String>['Thursday', 'Tuesday']);
      expect(stretch.completionLog, {
        '2026-05-12': HabitState.DONE,
        '2026-05-14': HabitState.NOT_DONE,
        '2026-06-02': HabitState.DONE,
      });
    },
  );

  test(
    'two different "Workout" habits with different weekdays stay separate — '
    '§12.8',
    () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.twoWorkoutsDifferentWeekdays(),
      );
      await runner.run();

      final items = await _depsOf(runner).datasource.getAll();
      expect(items.length, 2);

      // Same name — must be distinguished by the sorted-weekday key.
      final mwf = items.firstWhere(
        (it) => it.recurrence.weekdays!.contains('Monday'),
      );
      final tt = items.firstWhere(
        (it) => it.recurrence.weekdays!.contains('Tuesday'),
      );
      expect(mwf.name, 'Workout');
      expect(tt.name, 'Workout');
      // Sorted ASCII: [Friday, Monday, Wednesday] and [Thursday, Tuesday].
      expect(mwf.recurrence.weekdays, <String>[
        'Friday',
        'Monday',
        'Wednesday',
      ]);
      expect(tt.recurrence.weekdays, <String>['Thursday', 'Tuesday']);

      // Oldest-month id wins per dedup group.
      expect(mwf.id, 'WORKOUT_JAN');
      expect(mwf.createdDate, DateTime(2026, 1, 1));
      expect(tt.id, 'WORKOUT_JUN');
      expect(tt.createdDate, DateTime(2026, 6, 1));

      // Completion logs are scoped to each group's months.
      expect(mwf.completionLog.keys, contains('2026-01-05'));
      expect(mwf.completionLog.keys, contains('2026-02-04'));
      expect(mwf.completionLog.keys, contains('2026-03-06'));
      expect(mwf.completionLog.keys, isNot(contains('2026-06-02')));
      expect(tt.completionLog.keys, contains('2026-06-02'));
      expect(tt.completionLog.keys, contains('2026-06-04'));
      expect(tt.completionLog.keys, isNot(contains('2026-01-05')));
    },
  );

  test(
    'repeatDays order does not affect dedup — §12.8',
    () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.sameWeekdaySetDifferentOrder(),
      );
      await runner.run();

      final items = await _depsOf(runner).datasource.getAll();
      // Apr [Monday, Wednesday, Friday] and May [Friday, Monday, Wednesday]
      // have the same set — they must merge into ONE item via the sort.
      expect(items.length, 1);
      final read = items.single;
      expect(read.name, 'Read');
      expect(read.id, 'READ_APR'); // Oldest month wins.
      expect(read.createdDate, DateTime(2026, 4, 1));
      // Canonical sorted order is stored.
      expect(read.recurrence.weekdays, <String>[
        'Friday',
        'Monday',
        'Wednesday',
      ]);
      // Both months' logs are merged.
      expect(read.completionLog, {
        '2026-04-07': HabitState.DONE,
        '2026-05-08': HabitState.NOT_DONE,
      });
    },
  );

  test(
    'mid-life weekday-set edit produces two items (deliberate split) — '
    '§12.8 + §11.7',
    () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.midLifeWeekdayEdit(),
      );
      await runner.run();

      final items = await _depsOf(runner).datasource.getAll();
      // Mon/Wed/Fri group (Apr+May) and Mon/Wed/Fri/Sat group (Jun) split.
      expect(items.length, 2);

      final original = items.firstWhere(
        (it) => it.recurrence.weekdays!.length == 3,
      );
      final edited = items.firstWhere(
        (it) => it.recurrence.weekdays!.length == 4,
      );

      expect(original.name, 'Gym');
      expect(original.recurrence.weekdays, <String>[
        'Friday',
        'Monday',
        'Wednesday',
      ]);
      expect(original.id, 'GYM_APR');
      expect(original.completionLog, {
        '2026-04-06': HabitState.DONE,
        '2026-05-04': HabitState.DONE,
      });

      expect(edited.name, 'Gym');
      expect(edited.recurrence.weekdays, <String>[
        'Friday',
        'Monday',
        'Saturday',
        'Wednesday',
      ]);
      expect(edited.id, 'GYM_JUN');
      expect(edited.completionLog, {
        '2026-06-06': HabitState.DONE,
        '2026-06-13': HabitState.DONE,
      });
    },
  );

  test(
    'per-cell conflict resolves last-write-wins by month order — §6.3',
    () async {
      // Same dedup key (Ridge, Mon/Wed/Fri) in Apr and May; Apr day 15 -> DONE
      // produces 2026-04-15 entry; May day 15 -> NOT_DONE produces
      // 2026-05-15. The two ISO dates do NOT collide — they belong to
      // different months — so both end up in the merged log. The §6.3 rule
      // is reaffirmed: per-cell *same iso date* conflicts would resolve
      // last-write-wins via natural map overwrite. We additionally assert the
      // newer-month write *does not* get shadowed by the older.
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.perCellConflict(),
      );
      await runner.run();

      final items = await _depsOf(runner).datasource.getAll();
      expect(items.length, 1);
      final ridge = items.single;
      expect(ridge.completionLog['2026-04-15'], HabitState.DONE);
      expect(ridge.completionLog['2026-05-15'], HabitState.NOT_DONE);
    },
  );

  test(
    'same-iso-date conflict in same month blob: later record overwrites '
    'earlier (per-cell last-write-wins) — §6.3',
    () async {
      // Construct by hand: a single month blob containing two records with
      // the same dedup key, both with daysStates[10]. The second record's
      // state must win because iteration within a month preserves array
      // order and the overwrite is naked (no containsKey guard).
      final earlyDoneIso = jsonEncode([
        {
          'id': 'CONFLICT_A',
          'name': 'Walk',
          'createdDate': DateTime(2026, 6, 1).toIso8601String(),
          'repeatDays': <String>['Monday', 'Wednesday', 'Friday'],
          'daysStates': <String, dynamic>{'10': HabitState.DONE.index},
        },
        {
          'id': 'CONFLICT_B',
          'name': 'Walk',
          'createdDate': DateTime(2026, 6, 1).toIso8601String(),
          'repeatDays': <String>['Monday', 'Wednesday', 'Friday'],
          'daysStates': <String, dynamic>{'10': HabitState.NOT_DONE.index},
        },
      ]);
      final runner = await _buildRunner(
        legacy: {
          '${AppLocalStorageKeys.habitMonth}2026-6': earlyDoneIso,
        },
      );
      await runner.run();

      final items = await _depsOf(runner).datasource.getAll();
      expect(items.length, 1);
      // Later record wins — DONE has been overwritten with NOT_DONE.
      expect(items.single.completionLog['2026-06-10'], HabitState.NOT_DONE);
    },
  );

  test(
    'byte-identical APP/SCHEDULER/ITEMS across re-runs (idempotency)',
    () async {
      // First run.
      final runner1 = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner1.run();
      final firstBlob = _depsOf(
        runner1,
      ).storage.store[AppLocalStorageKeys.schedulerItems];
      expect(firstBlob, isNotNull);

      // Second run: a *fresh* runner over the same legacy seed, with the
      // V1_COMPLETE flag NOT set — simulates "clear the flag and re-run".
      final runner2 = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner2.run();
      final secondBlob = _depsOf(
        runner2,
      ).storage.store[AppLocalStorageKeys.schedulerItems];

      expect(secondBlob, equals(firstBlob));
    },
  );

  test('backup blob contains every APP/HABIT/* key from the seed', () async {
    final seed = LegacyHabitFixtures.threeMonthHabits();
    final runner = await _buildRunner(legacy: seed);
    await runner.run();

    final deps = _depsOf(runner);
    final rawBackup =
        deps.storage.store[AppLocalStorageKeys.schedulerMigrationV1Backup];
    expect(rawBackup, isNotNull);
    final backup = jsonDecode(rawBackup!) as Map<String, dynamic>;

    for (final key in seed.keys) {
      expect(
        backup.containsKey(key),
        isTrue,
        reason: 'backup missing key $key',
      );
    }
  });

  test(
    'legacy APP/HABIT/MONTH/* keys are not deleted after migration',
    () async {
      final seed = LegacyHabitFixtures.threeMonthHabits();
      final runner = await _buildRunner(legacy: seed);
      await runner.run();

      final deps = _depsOf(runner);
      for (final key in seed.keys) {
        if (key.startsWith(AppLocalStorageKeys.habitMonth)) {
          expect(
            deps.prefs.getString(key),
            seed[key],
            reason: 'legacy key $key should remain readable',
          );
        }
      }
    },
  );

  test('SUSPENDED state is preserved verbatim in completionLog', () async {
    final runner = await _buildRunner(
      legacy: LegacyHabitFixtures.threeMonthHabits(),
    );
    await runner.run();
    final walk = (await _depsOf(
      runner,
    ).datasource.getAll())
        .firstWhere((it) => it.name == 'Walk');
    expect(walk.completionLog['2026-05-06'], HabitState.SUSPENDED);
  });

  test('empty repeatDays habit is skipped (§12.5)', () async {
    // A standalone seed with one valid record + one record with empty
    // repeatDays. The valid one should still migrate.
    final emptyRepeatHabit = {
      'id': 'EMPTY001',
      'name': 'EmptyHabit',
      'createdDate': DateTime(2026, 6, 1).toIso8601String(),
      'repeatDays': <String>[],
      'daysStates': <String, dynamic>{},
    };
    final validHabit = {
      'id': 'VALID001',
      'name': 'ValidHabit',
      'createdDate': DateTime(2026, 6, 1).toIso8601String(),
      'repeatDays': <String>['Monday'],
      'daysStates': <String, dynamic>{'1': HabitState.DONE.index},
    };
    final legacy = {
      '${AppLocalStorageKeys.habitMonth}2026-6': jsonEncode([
        emptyRepeatHabit,
        validHabit,
      ]),
    };
    final runner = await _buildRunner(legacy: legacy);
    final summary = await runner.run();

    expect(summary.skippedNoRepeatDays, 1);
    expect(summary.skippedMalformed, 0);
    expect(summary.scheduledItemsCreated, 1);

    final items = await _depsOf(runner).datasource.getAll();
    expect(items.single.name, 'ValidHabit');
  });

  test(
    'malformed record is skipped, surrounding records still process',
    () async {
      final validHabit = {
        'id': 'VALID002',
        'name': 'ValidHabit',
        'createdDate': DateTime(2026, 6, 1).toIso8601String(),
        'repeatDays': <String>['Monday'],
        'daysStates': <String, dynamic>{'1': HabitState.DONE.index},
      };
      final malformed = {'this': 'is', 'not': 'a habit'};
      final legacy = {
        '${AppLocalStorageKeys.habitMonth}2026-6': jsonEncode([
          malformed,
          validHabit,
        ]),
      };
      final runner = await _buildRunner(legacy: legacy);
      final summary = await runner.run();

      expect(summary.skippedMalformed, 1);
      expect(summary.skippedNoRepeatDays, 0);
      expect(summary.scheduledItemsCreated, 1);
      expect(
        (await _depsOf(runner).datasource.getAll()).single.name,
        'ValidHabit',
      );
    },
  );

  test(
    'completion log uses zero-padded ISO keys from single-digit months',
    () async {
      // Seed: legacy key APP/HABIT/MONTH/2026-6 with day 7 -> iso "2026-06-07"
      final habit = {
        'id': 'PAD00001',
        'name': 'PadCheck',
        'createdDate': DateTime(2026, 6, 1).toIso8601String(),
        'repeatDays': <String>['Sunday'],
        'daysStates': <String, dynamic>{'7': HabitState.DONE.index},
      };
      final legacy = {
        '${AppLocalStorageKeys.habitMonth}2026-6': jsonEncode([habit]),
      };
      final runner = await _buildRunner(legacy: legacy);
      await runner.run();

      final item = (await _depsOf(runner).datasource.getAll()).single;
      expect(item.completionLog.keys, contains('2026-06-07'));
      expect(item.completionLog.keys, isNot(contains('2026-6-7')));
    },
  );

  test('migrated weekly items default carryOverEnabled to false', () async {
    final runner = await _buildRunner(
      legacy: LegacyHabitFixtures.threeMonthHabits(),
    );
    await runner.run();
    final items = await _depsOf(runner).datasource.getAll();
    for (final item in items) {
      expect(item.carryOverEnabled, isFalse, reason: item.name);
    }
  });

  test(
    'all migrated items have weekly recurrence with createdDate startDate',
    () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner.run();
      final items = await _depsOf(runner).datasource.getAll();
      for (final item in items) {
        expect(item.recurrence.kind, RecurrenceKind.weekly);
        expect(item.recurrence.startDate, item.createdDate);
      }
    },
  );

  test('summary print line uses the exact §12.5 format', () async {
    final logs = <String>[];
    await runZonedPrintCapture(logs, () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner.run();
    });

    final pattern = RegExp(
      r'^\[SchedulerMigration\] complete: \d+ items, \d+ entries, '
      r'skipped: \d+ \(\d+ no repeatDays, \d+ malformed\)$',
    );
    final match = logs.firstWhere(pattern.hasMatch, orElse: () => '');
    expect(match, isNotEmpty, reason: 'logs: $logs');
  });

  test(
    'Recurrence.weekly migrated items preserve full weekday names '
    '(canonical sorted order)',
    () async {
      final runner = await _buildRunner(
        legacy: LegacyHabitFixtures.threeMonthHabits(),
      );
      await runner.run();
      final walk = (await _depsOf(
        runner,
      ).datasource.getAll())
          .firstWhere((it) => it.name == 'Walk');
      final reread = Recurrence.fromJson(walk.recurrence.toJson());
      // §12.8 — stored weekdays are in canonical (sorted) order.
      expect(reread.weekdays, <String>['Friday', 'Monday', 'Wednesday']);
    },
  );

  test('ScheduledItem fully round-trips via the datasource blob', () async {
    final runner = await _buildRunner(
      legacy: LegacyHabitFixtures.threeMonthHabits(),
    );
    await runner.run();
    final stored = _depsOf(
      runner,
    ).storage.store[AppLocalStorageKeys.schedulerItems];
    expect(stored, isNotNull);
    final raw = jsonDecode(stored!) as List<dynamic>;
    final parsed = raw
        .map((e) => ScheduledItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    expect(parsed.length, 2);
    expect(parsed.map((it) => it.name).toSet(), {'Walk', 'Stretch'});
  });
}

/// Captures every `print(...)` emitted from [body] into [out]. The runner
/// uses `print` for its summary line; the §12.5 format test asserts on it.
Future<void> runZonedPrintCapture(
  List<String> out,
  Future<void> Function() body,
) async {
  await runZoned(
    body,
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) => out.add(line),
    ),
  );
}
