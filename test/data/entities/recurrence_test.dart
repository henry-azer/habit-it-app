import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/data/entities/recurrence.dart';
import 'package:habit_it/data/enums/recurrence_kind.dart';

void main() {
  group('Recurrence factory invariants', () {
    test('weekly rejects an empty weekdays list', () {
      expect(
        () => Recurrence.weekly(<String>[], DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('weekly rejects abbreviated weekday names', () {
      expect(
        () => Recurrence.weekly(<String>['Mon'], DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('weekly accepts full weekday names', () {
      final r = Recurrence.weekly(<String>[
        'Monday',
        'Wednesday',
        'Friday',
      ], DateTime(2026, 6, 7));
      expect(r.kind, RecurrenceKind.weekly);
      expect(r.weekdays, ['Monday', 'Wednesday', 'Friday']);
    });

    test('monthlyByDay rejects 0', () {
      expect(
        () => Recurrence.monthlyByDay(0, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('monthlyByDay rejects 32', () {
      expect(
        () => Recurrence.monthlyByDay(32, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('monthlyByDay accepts 1 and 31', () {
      expect(Recurrence.monthlyByDay(1, DateTime(2026, 6, 7)).dayOfMonth, 1);
      expect(Recurrence.monthlyByDay(31, DateTime(2026, 6, 7)).dayOfMonth, 31);
    });

    test('yearly rejects month=0', () {
      expect(
        () => Recurrence.yearly(0, 15, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('yearly rejects month=13', () {
      expect(
        () => Recurrence.yearly(13, 15, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('yearly rejects (Feb, 30) — invalid calendar date', () {
      expect(
        () => Recurrence.yearly(2, 30, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('yearly rejects (Apr, 31) — invalid calendar date', () {
      expect(
        () => Recurrence.yearly(4, 31, DateTime(2026, 6, 7)),
        throwsArgumentError,
      );
    });

    test('yearly accepts leap-day (Feb, 29) at construction', () {
      final r = Recurrence.yearly(2, 29, DateTime(2024, 1, 1));
      expect(r.yearlyMonth, 2);
      expect(r.yearlyDay, 29);
    });
  });

  group('Recurrence JSON round-trip', () {
    test('oneOff', () {
      final r = Recurrence.oneOff(DateTime(2026, 6, 12));
      final roundTripped = Recurrence.fromJson(r.toJson());
      expect(roundTripped.kind, RecurrenceKind.oneOff);
      expect(roundTripped.oneOffDate, DateTime(2026, 6, 12));
      expect(roundTripped.startDate, isNull);
    });

    test('daily', () {
      final r = Recurrence.daily(DateTime(2026, 6, 7));
      final roundTripped = Recurrence.fromJson(r.toJson());
      expect(roundTripped.kind, RecurrenceKind.daily);
      expect(roundTripped.startDate, DateTime(2026, 6, 7));
      expect(roundTripped.oneOffDate, isNull);
    });

    test('weekly', () {
      final r = Recurrence.weekly(<String>[
        'Monday',
        'Wednesday',
        'Friday',
      ], DateTime(2026, 6, 7));
      final roundTripped = Recurrence.fromJson(r.toJson());
      expect(roundTripped.kind, RecurrenceKind.weekly);
      expect(roundTripped.weekdays, ['Monday', 'Wednesday', 'Friday']);
      expect(roundTripped.startDate, DateTime(2026, 6, 7));
    });

    test('monthlyByDay', () {
      final r = Recurrence.monthlyByDay(15, DateTime(2026, 6, 7));
      final roundTripped = Recurrence.fromJson(r.toJson());
      expect(roundTripped.kind, RecurrenceKind.monthlyByDay);
      expect(roundTripped.dayOfMonth, 15);
      expect(roundTripped.startDate, DateTime(2026, 6, 7));
    });

    test('yearly', () {
      final r = Recurrence.yearly(4, 3, DateTime(2026, 6, 7));
      final roundTripped = Recurrence.fromJson(r.toJson());
      expect(roundTripped.kind, RecurrenceKind.yearly);
      expect(roundTripped.yearlyMonth, 4);
      expect(roundTripped.yearlyDay, 3);
      expect(roundTripped.startDate, DateTime(2026, 6, 7));
    });

    test('JSON omits null per-flavor fields', () {
      final r = Recurrence.oneOff(DateTime(2026, 6, 12));
      final json = r.toJson();
      expect(json.containsKey('startDate'), isFalse);
      expect(json.containsKey('weekdays'), isFalse);
      expect(json.containsKey('dayOfMonth'), isFalse);
      expect(json.containsKey('yearlyMonth'), isFalse);
      expect(json.containsKey('yearlyDay'), isFalse);
    });

    test('kind serialized by name, not by index', () {
      expect(
        Recurrence.monthlyByDay(15, DateTime(2026, 6, 7)).toJson()['kind'],
        'monthlyByDay',
      );
    });
  });
}
