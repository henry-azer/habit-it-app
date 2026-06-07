import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/datasources/scheduler/scheduled_item_local_datasource.dart';
import 'package:habit_it/data/entities/recurrence.dart';
import 'package:habit_it/data/entities/scheduled_item.dart';
import 'package:habit_it/data/enums/habit_state.dart';

import '../../../_fakes/fake_storage_manager.dart';

ScheduledItem _item(String id, String name, Recurrence recurrence) {
  return ScheduledItem(
    id: id,
    name: name,
    createdDate: DateTime(2026, 6, 7),
    recurrence: recurrence,
    completionLog: <String, HabitState>{},
    carryOverEnabled: false,
  );
}

void main() {
  late FakeStorageManager storage;
  late ScheduledItemLocalDataSourceImpl ds;

  setUp(() {
    storage = FakeStorageManager();
    ds = ScheduledItemLocalDataSourceImpl(storageManager: storage);
  });

  group('CRUD', () {
    test('getAll on empty store returns []', () async {
      expect(await ds.getAll(), isEmpty);
    });

    test('add then getAll returns the item', () async {
      final item = _item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 7)));
      await ds.add(item);
      final result = await ds.getAll();
      expect(result, hasLength(1));
      expect(result.first.id, 'A');
      expect(result.first.name, 'Walk');
    });

    test('getById returns the item; null when missing', () async {
      await ds.add(_item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 7))));
      expect((await ds.getById('A'))?.name, 'Walk');
      expect(await ds.getById('Z'), isNull);
    });

    test('update replaces the item by id', () async {
      final original = _item(
        'A',
        'Walk',
        Recurrence.daily(DateTime(2026, 6, 7)),
      );
      await ds.add(original);
      final renamed = _item('A', 'Run', Recurrence.daily(DateTime(2026, 6, 7)));
      await ds.update(renamed);
      expect((await ds.getById('A'))?.name, 'Run');
    });

    test('update on missing id is a no-op', () async {
      final ghost = _item('Z', 'Z', Recurrence.daily(DateTime(2026, 6, 7)));
      await ds.update(ghost);
      expect(await ds.getAll(), isEmpty);
    });
  });

  group('getOccurringOn', () {
    test('returns only items occurring on the queried date', () async {
      await ds.add(_item('A', 'Daily', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.add(
        _item(
          'B',
          'Only Mondays',
          Recurrence.weekly(<String>['Monday'], DateTime(2026, 6, 1)),
        ),
      );
      await ds.add(
        _item('C', 'Future', Recurrence.daily(DateTime(2026, 7, 1))),
      );

      // 2026-06-08 is a Monday: A (daily, after start) + B (Monday). C starts in July.
      final result = await ds.getOccurringOn(DateTime(2026, 6, 8));
      final ids = result.map((it) => it.id).toSet();
      expect(ids, {'A', 'B'});
    });

    test('returns empty when nothing matches', () async {
      await ds.add(
        _item(
          'A',
          'Mondays',
          Recurrence.weekly(<String>['Monday'], DateTime(2026, 6, 1)),
        ),
      );
      // 2026-06-07 is a Sunday.
      expect(await ds.getOccurringOn(DateTime(2026, 6, 7)), isEmpty);
    });
  });

  group('occurrence state', () {
    test('setOccurrenceState writes; getOccurrenceState reads back', () async {
      await ds.add(_item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.setOccurrenceState('A', DateTime(2026, 6, 10), HabitState.DONE);
      expect(
        await ds.getOccurrenceState('A', DateTime(2026, 6, 10)),
        HabitState.DONE,
      );
    });

    test('getOccurrenceState returns null for an unset (id, date)', () async {
      await ds.add(_item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 1))));
      expect(await ds.getOccurrenceState('A', DateTime(2026, 6, 10)), isNull);
    });

    test('setOccurrenceState on missing id is a no-op', () async {
      await ds.setOccurrenceState(
        'GHOST',
        DateTime(2026, 6, 10),
        HabitState.DONE,
      );
      expect(await ds.getAll(), isEmpty);
    });

    test(
      'concurrent setOccurrenceState calls all land (single-flight queue)',
      () async {
        await ds.add(
          _item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 1))),
        );

        // Fire 10 calls without awaiting between them — the single-flight
        // transaction queue must serialize the read-modify-write so none of
        // the writes are lost.
        final futures = <Future<void>>[];
        for (int day = 1; day <= 10; day++) {
          futures.add(
            ds.setOccurrenceState('A', DateTime(2026, 6, day), HabitState.DONE),
          );
        }
        await Future.wait(futures);

        final item = await ds.getById('A');
        expect(item, isNotNull);
        for (int day = 1; day <= 10; day++) {
          final iso = '2026-06-${day.toString().padLeft(2, '0')}';
          expect(
            item!.completionLog[iso],
            HabitState.DONE,
            reason: 'log should contain $iso',
          );
        }
        expect(item!.completionLog.length, 10);
      },
    );
  });

  group('reorder', () {
    test('moves an item to the position of the target', () async {
      await ds.add(_item('A', 'A', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.add(_item('B', 'B', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.add(_item('C', 'C', Recurrence.daily(DateTime(2026, 6, 1))));

      // Move C to A's position -> [C, A, B]
      await ds.reorder('C', 'A');
      final ids = (await ds.getAll()).map((it) => it.id).toList();
      expect(ids, ['C', 'A', 'B']);
    });

    test('reorder(A, A) is a no-op', () async {
      await ds.add(_item('A', 'A', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.add(_item('B', 'B', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.reorder('A', 'A');
      final ids = (await ds.getAll()).map((it) => it.id).toList();
      expect(ids, ['A', 'B']);
    });

    test('reorder with a missing id is a no-op', () async {
      await ds.add(_item('A', 'A', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.add(_item('B', 'B', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.reorder('GHOST', 'A');
      final ids = (await ds.getAll()).map((it) => it.id).toList();
      expect(ids, ['A', 'B']);
    });

    test('persistent JSON has no sortOrder field', () async {
      await ds.add(_item('A', 'A', Recurrence.daily(DateTime(2026, 6, 1))));
      final raw = storage.store[AppLocalStorageKeys.schedulerItems]!;
      expect(raw.contains('sortOrder'), isFalse);
    });
  });

  group('remove (hard-delete)', () {
    test('drops the item and its completionLog from the blob', () async {
      final item = _item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 1)));
      item.completionLog['2026-06-01'] = HabitState.DONE;
      item.completionLog['2026-06-02'] = HabitState.NOT_DONE;
      await ds.add(item);

      await ds.remove('A');

      final raw = storage.store[AppLocalStorageKeys.schedulerItems];
      expect(raw, isNotNull);
      expect(raw!.contains('2026-06-01'), isFalse);
      expect(raw.contains('2026-06-02'), isFalse);
      expect(raw.contains('"A"'), isFalse);
      expect(await ds.getAll(), isEmpty);
    });

    test('removed item is no longer returned by getOccurringOn', () async {
      await ds.add(_item('A', 'Daily', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.remove('A');
      expect(await ds.getOccurringOn(DateTime(2026, 6, 10)), isEmpty);
    });

    test('remove on missing id is a no-op', () async {
      await ds.add(_item('A', 'A', Recurrence.daily(DateTime(2026, 6, 1))));
      await ds.remove('GHOST');
      expect((await ds.getAll()).single.id, 'A');
    });
  });

  test('written blob lives under the single APP/SCHEDULER/ITEMS key', () async {
    await ds.add(_item('A', 'Walk', Recurrence.daily(DateTime(2026, 6, 1))));
    expect(storage.store.keys, [AppLocalStorageKeys.schedulerItems]);
  });
}
