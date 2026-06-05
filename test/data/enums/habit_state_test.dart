import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/data/enums/habit_state.dart';

void main() {
  group('HabitState', () {
    test('legacy ordinals map to expected enum values', () {
      expect(HabitState.fromLegacyIndex(0), HabitState.CREATED);
      expect(HabitState.fromLegacyIndex(1), HabitState.DONE);
      expect(HabitState.fromLegacyIndex(2), HabitState.NOT_DONE);
      expect(HabitState.fromLegacyIndex(3), HabitState.SUSPENDED);
      expect(HabitState.fromLegacyIndex(4), HabitState.IN_PROGRESS);
    });

    test('out-of-range ordinals fall back to CREATED', () {
      expect(HabitState.fromLegacyIndex(-1), HabitState.CREATED);
      expect(HabitState.fromLegacyIndex(99), HabitState.CREATED);
    });

    test('fromJsonDynamic accepts both int and string', () {
      expect(HabitState.fromJsonDynamic(1), HabitState.DONE);
      expect(HabitState.fromJsonDynamic('DONE'), HabitState.DONE);
      expect(HabitState.fromJsonDynamic('NOT_DONE'), HabitState.NOT_DONE);
      expect(HabitState.fromJsonDynamic('IN_PROGRESS'), HabitState.IN_PROGRESS);
      expect(HabitState.fromJsonDynamic(null), HabitState.CREATED);
      expect(HabitState.fromJsonDynamic('garbage'), HabitState.CREATED);
    });

    test('wireName round-trips', () {
      for (final s in HabitState.values) {
        expect(HabitState.fromJsonDynamic(s.wireName), s);
      }
    });
  });
}
