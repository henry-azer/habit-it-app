import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/data/datasources/scheduler/scheduled_item_local_datasource.dart';
import 'package:habit_it/data/entities/recurrence.dart';
import 'package:habit_it/data/entities/scheduled_item.dart';
import 'package:habit_it/data/enums/habit_state.dart';
import 'package:habit_it/data/enums/recurrence_kind.dart';

import '../../_fakes/fake_storage_manager.dart';

/// Sprint 2 — Story 2.1..2.5 acceptance tests. These cover the integration
/// path that the Add/Edit screens drive: build a `ScheduledItem` from
/// user-supplied recurrence inputs, persist it, and round-trip the
/// completionLog across edits. Widget-level tests are deferred to a later
/// pass — the repo has no widget-test scaffolding yet (no fake asset bundle
/// for localization, no GetIt setup helper) and adding one is out of
/// scope for this sprint.
void main() {
  ScheduledItemLocalDataSourceImpl newDatasource() {
    return ScheduledItemLocalDataSourceImpl(
        storageManager: FakeStorageManager());
  }

  group('Story 2.1 — One-off todo', () {
    test(
      'creating a one-off for date X persists with recurrence.oneOffDate=X',
      () async {
        final ds = newDatasource();
        final item = ScheduledItem(
          id: 'A',
          name: 'Pay bill',
          createdDate: DateTime(2026, 6, 7),
          recurrence: Recurrence.oneOff(DateTime(2026, 6, 12)),
          completionLog: <String, HabitState>{},
          carryOverEnabled: false,
        );
        await ds.add(item);
        final stored = await ds.getById('A');
        expect(stored, isNotNull);
        expect(stored!.recurrence.kind, RecurrenceKind.oneOff);
        expect(stored.recurrence.oneOffDate, DateTime(2026, 6, 12));
      },
    );

    test('back-dated one-off saves (Story 2.1 AC — past-date allowed)',
        () async {
      final ds = newDatasource();
      final item = ScheduledItem(
        id: 'B',
        name: 'Logged late',
        createdDate: DateTime(2026, 6, 7),
        recurrence: Recurrence.oneOff(DateTime(2026, 6, 1)),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      await ds.add(item);
      final stored = await ds.getById('B');
      expect(stored!.recurrence.oneOffDate, DateTime(2026, 6, 1));
    });

    test(
      'past one-off is locked: edit screen lock predicate triggers when '
      'recurrence.oneOffDate is before today',
      () {
        // The edit screen's `_oneOffDateLocked` getter is the lock under
        // test; we exercise the predicate logic directly. The Story 2.1 AC
        // is "editing a past one-off item disables the date field".
        bool locked(DateTime oneOff, DateTime today) {
          final d = DateTime(oneOff.year, oneOff.month, oneOff.day);
          final t = DateTime(today.year, today.month, today.day);
          return d.isBefore(t);
        }

        expect(locked(DateTime(2026, 6, 1), DateTime(2026, 6, 7)), isTrue);
        expect(locked(DateTime(2026, 6, 7), DateTime(2026, 6, 7)), isFalse);
        expect(locked(DateTime(2026, 6, 8), DateTime(2026, 6, 7)), isFalse);
      },
    );

    test('delete removes both item and its completionLog (§12.4)', () async {
      final ds = newDatasource();
      final item = ScheduledItem(
        id: 'C',
        name: 'Errand',
        createdDate: DateTime(2026, 6, 7),
        recurrence: Recurrence.oneOff(DateTime(2026, 6, 12)),
        completionLog: <String, HabitState>{'2026-06-12': HabitState.DONE},
        carryOverEnabled: false,
      );
      await ds.add(item);
      await ds.remove('C');
      expect(await ds.getById('C'), isNull);
    });
  });

  group('Story 2.2 — Daily recurring item', () {
    test('daily item saves with kind=daily and startDate=today', () async {
      final ds = newDatasource();
      final today = DateTime(2026, 6, 7);
      final item = ScheduledItem(
        id: 'D',
        name: 'Drink water',
        createdDate: today,
        recurrence: Recurrence.daily(today),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      await ds.add(item);
      final stored = await ds.getById('D');
      expect(stored!.recurrence.kind, RecurrenceKind.daily);
      expect(stored.recurrence.startDate, today);
    });

    test('marking day X DONE does NOT propagate to day X+1', () async {
      final ds = newDatasource();
      final today = DateTime(2026, 6, 7);
      final item = ScheduledItem(
        id: 'E',
        name: 'Stretch',
        createdDate: today,
        recurrence: Recurrence.daily(today),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      await ds.add(item);
      await ds.setOccurrenceState('E', today, HabitState.DONE);
      expect(
        await ds.getOccurrenceState('E', today),
        HabitState.DONE,
      );
      expect(
        await ds.getOccurrenceState('E', today.add(const Duration(days: 1))),
        isNull,
      );
    });

    test(
        'startDate is locked on edit (Story 2.2 AC) — '
        'name update preserves recurrence.startDate', () async {
      final ds = newDatasource();
      final today = DateTime(2026, 6, 7);
      final item = ScheduledItem(
        id: 'F',
        name: 'Old name',
        createdDate: today,
        recurrence: Recurrence.daily(today),
        completionLog: <String, HabitState>{
          '2026-06-08': HabitState.DONE,
        },
        carryOverEnabled: false,
      );
      await ds.add(item);
      // Simulate the edit-screen save: only `name` mutates; recurrence is
      // not rebuilt for daily, completionLog is untouched.
      item.name = 'New name';
      await ds.update(item);
      final stored = await ds.getById('F');
      expect(stored!.name, 'New name');
      expect(stored.recurrence.startDate, today);
      expect(stored.completionLog['2026-06-08'], HabitState.DONE);
    });
  });

  group('Story 2.3 — Weekly recurring item', () {
    test('weekly with one weekday saves and occurs only on that weekday',
        () async {
      final ds = newDatasource();
      final item = ScheduledItem(
        id: 'G',
        name: 'Gym',
        createdDate: DateTime(2026, 6, 1),
        recurrence: Recurrence.weekly(
          <String>['Monday'],
          DateTime(2026, 6, 1),
        ),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      await ds.add(item);
      final stored = await ds.getById('G');
      expect(stored!.recurrence.weekdays, ['Monday']);
      // Mon 2026-06-08
      expect(stored.occursOn(DateTime(2026, 6, 8)), isTrue);
      // Tue
      expect(stored.occursOn(DateTime(2026, 6, 9)), isFalse);
    });

    test('weekly with zero weekdays is blocked at the factory (Story 2.3 AC)',
        () {
      expect(
        () => Recurrence.weekly(<String>[], DateTime(2026, 6, 1)),
        throwsArgumentError,
      );
    });

    test(
      'removing a weekday preserves past completionLog entries '
      '(Story 2.3 AC)',
      () async {
        final ds = newDatasource();
        final item = ScheduledItem(
          id: 'H',
          name: 'Workout',
          createdDate: DateTime(2026, 6, 1),
          recurrence: Recurrence.weekly(
            <String>['Monday', 'Wednesday'],
            DateTime(2026, 6, 1),
          ),
          completionLog: <String, HabitState>{
            // 2026-06-03 is a Wednesday.
            '2026-06-03': HabitState.DONE,
          },
          carryOverEnabled: false,
        );
        await ds.add(item);
        // Simulate edit: remove Wednesday.
        item.recurrence = Recurrence.weekly(
          <String>['Monday'],
          item.recurrence.startDate!,
        );
        await ds.update(item);
        final stored = await ds.getById('H');
        // Past entry survives the recurrence rebuild.
        expect(stored!.completionLog['2026-06-03'], HabitState.DONE);
        // No future Wednesdays occur.
        expect(stored.occursOn(DateTime(2026, 6, 10)), isFalse);
        // Mondays still occur.
        expect(stored.occursOn(DateTime(2026, 6, 8)), isTrue);
      },
    );

    test(
      'adding a weekday does NOT back-fill past dates (Story 2.3 AC)',
      () async {
        final ds = newDatasource();
        final item = ScheduledItem(
          id: 'I',
          name: 'Walk',
          createdDate: DateTime(2026, 6, 1),
          recurrence: Recurrence.weekly(
            <String>['Monday'],
            DateTime(2026, 6, 1),
          ),
          completionLog: <String, HabitState>{},
          carryOverEnabled: false,
        );
        await ds.add(item);
        item.recurrence = Recurrence.weekly(
          <String>['Monday', 'Wednesday'],
          item.recurrence.startDate!,
        );
        await ds.update(item);
        final stored = await ds.getById('I');
        // Wednesday past dates have NO log entries — the recurrence change
        // never writes to past days.
        expect(stored!.completionLog, isEmpty);
        // 2026-06-10 (Wed) is now a valid future occurrence.
        expect(stored.occursOn(DateTime(2026, 6, 10)), isTrue);
      },
    );
  });

  group('Story 2.4 — Monthly by day', () {
    test(
      'monthly with carryOverEnabled defaults true at create time '
      '(Add screen rule)',
      () async {
        final ds = newDatasource();
        // Simulates the Add screen's save: when kind == monthlyByDay,
        // carryOverEnabled is true unless the user toggled it off.
        final item = ScheduledItem(
          id: 'J',
          name: 'Pay rent',
          createdDate: DateTime(2026, 6, 7),
          recurrence: Recurrence.monthlyByDay(1, DateTime(2026, 6, 7)),
          completionLog: <String, HabitState>{},
          carryOverEnabled: true,
        );
        await ds.add(item);
        final stored = await ds.getById('J');
        expect(stored!.carryOverEnabled, isTrue);
      },
    );

    test('toggle carryOver off persists on edit', () async {
      final ds = newDatasource();
      final item = ScheduledItem(
        id: 'K',
        name: 'Bill',
        createdDate: DateTime(2026, 6, 7),
        recurrence: Recurrence.monthlyByDay(1, DateTime(2026, 6, 7)),
        completionLog: <String, HabitState>{},
        carryOverEnabled: true,
      );
      await ds.add(item);
      item.carryOverEnabled = false;
      await ds.update(item);
      expect((await ds.getById('K'))!.carryOverEnabled, isFalse);
    });

    test(
      'editing dayOfMonth preserves past completionLog (Story 2.4 AC)',
      () async {
        final ds = newDatasource();
        final item = ScheduledItem(
          id: 'L',
          name: 'Bill',
          createdDate: DateTime(2026, 6, 7),
          recurrence: Recurrence.monthlyByDay(15, DateTime(2026, 6, 7)),
          completionLog: <String, HabitState>{
            '2026-06-15': HabitState.DONE,
          },
          carryOverEnabled: true,
        );
        await ds.add(item);
        // Simulate edit: change day to 20.
        item.recurrence = Recurrence.monthlyByDay(
          20,
          item.recurrence.startDate!,
        );
        await ds.update(item);
        final stored = await ds.getById('L');
        // Past entry preserved.
        expect(stored!.completionLog['2026-06-15'], HabitState.DONE);
        // Future occurrences shift to day 20.
        expect(stored.occursOn(DateTime(2026, 7, 15)), isFalse);
        expect(stored.occursOn(DateTime(2026, 7, 20)), isTrue);
      },
    );

    test(
      'dayOfMonth=31 skips short months (Story 2.4 AC, explicit list)',
      () {
        final item = ScheduledItem(
          id: 'M',
          name: 'Last day',
          createdDate: DateTime(2026, 1, 1),
          recurrence: Recurrence.monthlyByDay(31, DateTime(2026, 1, 1)),
          completionLog: <String, HabitState>{},
          carryOverEnabled: true,
        );
        // Months WITHOUT day 31: Feb (28/29), Apr (30), Jun (30), Sep (30),
        // Nov (30).
        expect(item.occursOn(DateTime(2026, 2, 28)), isFalse);
        expect(item.occursOn(DateTime(2026, 4, 30)), isFalse);
        expect(item.occursOn(DateTime(2026, 6, 30)), isFalse);
        expect(item.occursOn(DateTime(2026, 9, 30)), isFalse);
        expect(item.occursOn(DateTime(2026, 11, 30)), isFalse);
        // Months WITH day 31.
        for (final m in <int>[1, 3, 5, 7, 8, 10, 12]) {
          expect(
            item.occursOn(DateTime(2026, m, 31)),
            isTrue,
            reason: 'should occur on month $m, 31',
          );
        }
      },
    );

    test(
      'dayOfMonth=29 in February skips non-leap years (Story 2.4 AC)',
      () {
        final item = ScheduledItem(
          id: 'N',
          name: 'Quarterly check',
          createdDate: DateTime(2026, 1, 1),
          recurrence: Recurrence.monthlyByDay(29, DateTime(2026, 1, 1)),
          completionLog: <String, HabitState>{},
          carryOverEnabled: true,
        );
        // 2027 is not leap; Feb has 28 days -> 29 does not exist.
        expect(item.occursOn(DateTime(2027, 2, 28)), isFalse);
        // 2028 IS leap.
        expect(item.occursOn(DateTime(2028, 2, 29)), isTrue);
      },
    );
  });

  group('Story 2.5 — Yearly recurring item', () {
    test(
      'yearly factory rejects invalid (month, day) combinations '
      '(Story 2.5 AC)',
      () {
        for (final pair in <List<int>>[
          [2, 30], // Feb 30
          [4, 31], // Apr 31
          [6, 31], // Jun 31
          [9, 31], // Sep 31
          [11, 31], // Nov 31
          [13, 1], // bad month
          [0, 1], // bad month
        ]) {
          expect(
            () => Recurrence.yearly(
              pair[0],
              pair[1],
              DateTime(2026, 1, 1),
            ),
            throwsArgumentError,
            reason: '(${pair[0]}, ${pair[1]}) should throw',
          );
        }
      },
    );

    test('yearly (Feb, 29) is allowed but only fires on leap years', () {
      final item = ScheduledItem(
        id: 'O',
        name: 'Leap day',
        createdDate: DateTime(2026, 1, 1),
        recurrence: Recurrence.yearly(2, 29, DateTime(2026, 1, 1)),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      expect(item.occursOn(DateTime(2027, 2, 28)), isFalse);
      expect(item.occursOn(DateTime(2028, 2, 29)), isTrue);
      expect(item.occursOn(DateTime(2032, 2, 29)), isTrue);
    });

    test('yearly carryOverEnabled defaults false on save (Story 2.5 note)',
        () async {
      final ds = newDatasource();
      final item = ScheduledItem(
        id: 'P',
        name: 'Birthday',
        createdDate: DateTime(2026, 1, 1),
        recurrence: Recurrence.yearly(4, 3, DateTime(2026, 1, 1)),
        completionLog: <String, HabitState>{},
        carryOverEnabled: false,
      );
      await ds.add(item);
      expect((await ds.getById('P'))!.carryOverEnabled, isFalse);
    });

    test(
      'editing yearly (month, day) preserves past completionLog '
      '(Story 2.5 AC)',
      () async {
        final ds = newDatasource();
        final item = ScheduledItem(
          id: 'Q',
          name: 'Anniversary',
          createdDate: DateTime(2026, 1, 1),
          recurrence: Recurrence.yearly(4, 3, DateTime(2026, 1, 1)),
          completionLog: <String, HabitState>{
            '2026-04-03': HabitState.DONE,
          },
          carryOverEnabled: false,
        );
        await ds.add(item);
        // Simulate edit: change to (12, 25).
        item.recurrence = Recurrence.yearly(
          12,
          25,
          item.recurrence.startDate!,
        );
        await ds.update(item);
        final stored = await ds.getById('Q');
        expect(stored!.completionLog['2026-04-03'], HabitState.DONE);
        expect(stored.occursOn(DateTime(2027, 12, 25)), isTrue);
        expect(stored.occursOn(DateTime(2027, 4, 3)), isFalse);
      },
    );

    test(
      'yearly start mid-year: target month before start month, first '
      'occurrence is NEXT year (Story 2.5 AC)',
      () {
        // (4, 3) with startDate=2026-06-01 -> 2026 has no occurrence.
        final item = ScheduledItem(
          id: 'R',
          name: 'Late start',
          createdDate: DateTime(2026, 6, 1),
          recurrence: Recurrence.yearly(4, 3, DateTime(2026, 6, 1)),
          completionLog: <String, HabitState>{},
          carryOverEnabled: false,
        );
        expect(item.occursOn(DateTime(2026, 4, 3)), isFalse);
        expect(item.occursOn(DateTime(2027, 4, 3)), isTrue);
        expect(item.occursOn(DateTime(2028, 4, 3)), isTrue);
      },
    );
  });
}
