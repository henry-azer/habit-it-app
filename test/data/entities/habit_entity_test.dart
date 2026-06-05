import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/data/entities/habit_entity.dart';
import 'package:habit_it/data/entities/habit_schedule.dart';
import 'package:habit_it/data/enums/habit_state.dart';

void main() {
  group('HabitEntity', () {
    test('round-trips modern JSON with wireName daysStates', () {
      final entity = HabitEntity(
        id: 'h1',
        name: 'Read 10 pages',
        createdDate: DateTime.utc(2026, 6, 2),
        schedule: const HabitSchedule.weekly(weekdays: ['Monday', 'Wednesday']),
        daysStates: const {2: HabitState.DONE, 5: HabitState.NOT_DONE},
      );
      final json = entity.toJson();
      final back = HabitEntity.fromJson(json);
      expect(back.id, entity.id);
      expect(back.name, entity.name);
      expect(back.daysStates[2], HabitState.DONE);
      expect(back.daysStates[5], HabitState.NOT_DONE);
    });

    test('parses legacy daysStates with int indices', () {
      final legacyJson = {
        'id': 'h2',
        'name': 'Walk',
        'createdDate': DateTime.utc(2026, 5, 1).toIso8601String(),
        'schedule': {'runtimeType': 'daily'},
        'daysStates': {'1': 1, '2': 2}, // 1=DONE, 2=NOT_DONE
        'progress': <String, int>{},
        'reminder': null,
        'target': null,
        'categoryId': null,
        'noteIds': <String>[],
        'sortIndex': 0,
      };
      final entity = HabitEntity.fromJson(legacyJson);
      expect(entity.daysStates[1], HabitState.DONE);
      expect(entity.daysStates[2], HabitState.NOT_DONE);
    });
  });

  group('HabitSchedule.shouldShowOn', () {
    test('daily fires every day', () {
      const sched = HabitSchedule.daily();
      expect(sched.shouldShowOn(DateTime(2026, 6, 5)), isTrue);
      expect(sched.shouldShowOn(DateTime(2026, 12, 25)), isTrue);
    });

    test('weekly fires only on listed weekdays', () {
      const sched = HabitSchedule.weekly(weekdays: ['Monday', 'Friday']);
      expect(sched.shouldShowOn(DateTime(2026, 6, 1)), isTrue); // Monday
      expect(sched.shouldShowOn(DateTime(2026, 6, 5)), isTrue); // Friday
      expect(sched.shouldShowOn(DateTime(2026, 6, 2)), isFalse); // Tuesday
    });

    test('none never fires', () {
      const sched = HabitSchedule.none();
      expect(sched.shouldShowOn(DateTime(2026, 6, 1)), isFalse);
    });
  });
}
