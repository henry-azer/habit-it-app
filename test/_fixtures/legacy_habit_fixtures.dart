import 'dart:convert';

import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/data/enums/habit_state.dart';

/// Builders for legacy storage payloads consumed by the migration tests.
/// Output shapes mirror the real `Habit.toJson` output so the migration runner
/// reads them through the same code path it would in production.
class LegacyHabitFixtures {
  /// Three-month seed:
  ///   - "Walk" (Mon/Wed/Fri, created Apr 1) appears in Apr / May / Jun ->
  ///     dedupes to a single ScheduledItem with combined completion log.
  ///   - "Stretch" (Tue/Thu, created May 10) appears in May / Jun -> dedupes
  ///     to one item.
  ///
  /// Legacy month strings are NOT zero-padded — the migration handles this.
  static Map<String, String> threeMonthHabits() {
    final walkApr = Habit(
      id: 'WALK0001',
      name: 'Walk',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{
        1: HabitState.DONE,
        3: HabitState.NOT_DONE,
        6: HabitState.DONE,
      },
    );
    final walkMay = Habit(
      id: 'WALK0001',
      name: 'Walk',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{
        4: HabitState.DONE,
        6: HabitState.SUSPENDED,
        8: HabitState.DONE,
      },
    );
    final walkJun = Habit(
      id: 'WALK0001',
      name: 'Walk',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{
        1: HabitState.NOT_DONE,
        15: HabitState.DONE,
      },
    );

    final stretchMay = Habit(
      id: 'STRETCH1',
      name: 'Stretch',
      createdDate: DateTime(2026, 5, 10),
      repeatDays: <String>['Tuesday', 'Thursday'],
      daysStates: <int, HabitState>{
        12: HabitState.DONE,
        14: HabitState.NOT_DONE,
      },
    );
    final stretchJun = Habit(
      id: 'STRETCH1',
      name: 'Stretch',
      createdDate: DateTime(2026, 5, 10),
      repeatDays: <String>['Tuesday', 'Thursday'],
      daysStates: <int, HabitState>{2: HabitState.DONE},
    );

    return {
      '${AppLocalStorageKeys.habitMonth}2026-4': _encode([walkApr]),
      '${AppLocalStorageKeys.habitMonth}2026-5': _encode([walkMay, stretchMay]),
      '${AppLocalStorageKeys.habitMonth}2026-6': _encode([walkJun, stretchJun]),
      '${AppLocalStorageKeys.habitMonthInit}2026-4': jsonEncode(true),
      '${AppLocalStorageKeys.habitMonthInit}2026-5': jsonEncode(true),
      '${AppLocalStorageKeys.habitMonthInit}2026-6': jsonEncode(true),
      '${AppLocalStorageKeys.habitInit}2026-6-7': jsonEncode(true),
    };
  }

  static String _encode(List<Habit> habits) {
    return jsonEncode(habits.map((h) => h.toJson()).toList());
  }
}
