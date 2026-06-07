import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/data/entities/recurrence.dart';
import 'package:habit_it/data/entities/scheduled_item.dart';
import 'package:habit_it/data/enums/habit_state.dart';

ScheduledItem _make({
  String id = 'X1Y2Z3',
  String name = 'Sample',
  required Recurrence recurrence,
  Map<String, HabitState>? log,
  bool carryOver = false,
  DateTime? createdDate,
}) {
  return ScheduledItem(
    id: id,
    name: name,
    createdDate: createdDate ?? DateTime(2026, 6, 7),
    recurrence: recurrence,
    completionLog: log ?? <String, HabitState>{},
    carryOverEnabled: carryOver,
  );
}

void main() {
  group('ScheduledItem.occursOn — oneOff', () {
    final item = _make(recurrence: Recurrence.oneOff(DateTime(2026, 6, 12)));
    test('true on the exact date', () {
      expect(item.occursOn(DateTime(2026, 6, 12)), isTrue);
    });
    test('false on the day before', () {
      expect(item.occursOn(DateTime(2026, 6, 11)), isFalse);
    });
    test('false on the day after', () {
      expect(item.occursOn(DateTime(2026, 6, 13)), isFalse);
    });
  });

  group('ScheduledItem.occursOn — daily', () {
    final item = _make(recurrence: Recurrence.daily(DateTime(2026, 6, 7)));
    test('false before startDate', () {
      expect(item.occursOn(DateTime(2026, 6, 6)), isFalse);
    });
    test('true on startDate', () {
      expect(item.occursOn(DateTime(2026, 6, 7)), isTrue);
    });
    test('true any day after startDate', () {
      expect(item.occursOn(DateTime(2026, 6, 30)), isTrue);
      expect(item.occursOn(DateTime(2027, 1, 1)), isTrue);
    });
  });

  group('ScheduledItem.occursOn — weekly', () {
    // June 7 2026 is a Sunday (verified: 2026-06-07).
    // Start date June 1 2026 (Monday).
    final item = _make(
      recurrence: Recurrence.weekly(<String>[
        'Monday',
        'Wednesday',
        'Friday',
      ], DateTime(2026, 6, 1)),
    );
    test('false before startDate', () {
      expect(item.occursOn(DateTime(2026, 5, 31)), isFalse);
    });
    test('Mon/Wed/Fri pass, Tue/Thu/Sat/Sun fail across one week', () {
      expect(item.occursOn(DateTime(2026, 6, 1)), isTrue); // Mon
      expect(item.occursOn(DateTime(2026, 6, 2)), isFalse); // Tue
      expect(item.occursOn(DateTime(2026, 6, 3)), isTrue); // Wed
      expect(item.occursOn(DateTime(2026, 6, 4)), isFalse); // Thu
      expect(item.occursOn(DateTime(2026, 6, 5)), isTrue); // Fri
      expect(item.occursOn(DateTime(2026, 6, 6)), isFalse); // Sat
      expect(item.occursOn(DateTime(2026, 6, 7)), isFalse); // Sun
    });
  });

  group('ScheduledItem.occursOn — monthlyByDay', () {
    test('day=31 in April (30-day month) is false', () {
      final item = _make(
        recurrence: Recurrence.monthlyByDay(31, DateTime(2026, 1, 1)),
      );
      expect(item.occursOn(DateTime(2026, 4, 30)), isFalse);
      expect(item.occursOn(DateTime(2026, 5, 31)), isTrue);
    });

    test('day=31 in February is false', () {
      final item = _make(
        recurrence: Recurrence.monthlyByDay(31, DateTime(2026, 1, 1)),
      );
      expect(item.occursOn(DateTime(2026, 2, 28)), isFalse);
    });

    test('day=15 on day 15 across multiple months is true', () {
      final item = _make(
        recurrence: Recurrence.monthlyByDay(15, DateTime(2026, 1, 1)),
      );
      expect(item.occursOn(DateTime(2026, 1, 15)), isTrue);
      expect(item.occursOn(DateTime(2026, 6, 15)), isTrue);
      expect(item.occursOn(DateTime(2026, 12, 15)), isTrue);
    });

    test('start-month: target day before start day skips first month', () {
      // Start June 20, target the 15th -> first occurrence is July 15.
      final item = _make(
        recurrence: Recurrence.monthlyByDay(15, DateTime(2026, 6, 20)),
      );
      expect(item.occursOn(DateTime(2026, 6, 15)), isFalse);
      expect(item.occursOn(DateTime(2026, 7, 15)), isTrue);
    });

    test('29-day cycle in February — leap-year sensitivity', () {
      final item = _make(
        recurrence: Recurrence.monthlyByDay(29, DateTime(2026, 1, 1)),
      );
      // 2027 is not a leap year -> Feb 29 does not exist; skip.
      expect(item.occursOn(DateTime(2027, 2, 28)), isFalse);
      // 2028 is a leap year -> Feb 29 exists; recurrence fires.
      expect(item.occursOn(DateTime(2028, 2, 29)), isTrue);
    });
  });

  group('ScheduledItem.occursOn — yearly', () {
    test('false on non-matching month', () {
      final item = _make(
        recurrence: Recurrence.yearly(4, 3, DateTime(2026, 1, 1)),
      );
      expect(item.occursOn(DateTime(2026, 5, 3)), isFalse);
    });

    test('true on matching (month, day) every year from startDate forward', () {
      final item = _make(
        recurrence: Recurrence.yearly(12, 25, DateTime(2026, 1, 1)),
      );
      expect(item.occursOn(DateTime(2026, 12, 25)), isTrue);
      expect(item.occursOn(DateTime(2030, 12, 25)), isTrue);
    });

    test('false before startDate', () {
      final item = _make(
        recurrence: Recurrence.yearly(1, 1, DateTime(2026, 6, 7)),
      );
      expect(item.occursOn(DateTime(2026, 1, 1)), isFalse);
    });

    test('(Feb, 29) is false on non-leap year, true on leap', () {
      final item = _make(
        recurrence: Recurrence.yearly(2, 29, DateTime(2024, 1, 1)),
      );
      expect(item.occursOn(DateTime(2027, 2, 28)), isFalse);
      expect(item.occursOn(DateTime(2028, 2, 29)), isTrue);
    });
  });

  group('ScheduledItem.stateOn', () {
    test('returns CREATED when log has no entry for the date', () {
      final item = _make(recurrence: Recurrence.daily(DateTime(2026, 6, 7)));
      expect(item.stateOn(DateTime(2026, 6, 7)), HabitState.CREATED);
    });

    test('reads from log when entry exists', () {
      final item = _make(
        recurrence: Recurrence.daily(DateTime(2026, 6, 7)),
        log: {'2026-06-07': HabitState.DONE},
      );
      expect(item.stateOn(DateTime(2026, 6, 7)), HabitState.DONE);
    });
  });

  group('ScheduledItem JSON round-trip', () {
    for (final entry in <String, Recurrence>{
      'oneOff': Recurrence.oneOff(DateTime(2026, 6, 12)),
      'daily': Recurrence.daily(DateTime(2026, 6, 7)),
      'weekly': Recurrence.weekly(<String>[
        'Monday',
        'Wednesday',
      ], DateTime(2026, 6, 7)),
      'monthlyByDay': Recurrence.monthlyByDay(15, DateTime(2026, 6, 7)),
      'yearly': Recurrence.yearly(4, 3, DateTime(2026, 6, 7)),
    }.entries) {
      test('round-trips ${entry.key}', () {
        final item = _make(
          recurrence: entry.value,
          log: {
            '2026-06-07': HabitState.DONE,
            '2026-06-08': HabitState.SUSPENDED,
          },
          carryOver: entry.key == 'monthlyByDay',
        );
        final json = item.toJson();
        final restored = ScheduledItem.fromJson(json);

        expect(restored.id, item.id);
        expect(restored.name, item.name);
        expect(restored.createdDate, item.createdDate);
        expect(restored.carryOverEnabled, item.carryOverEnabled);
        expect(restored.completionLog, item.completionLog);
        // Equality of Recurrence is structural via JSON.
        expect(restored.recurrence.toJson(), item.recurrence.toJson());
      });
    }
  });
}
