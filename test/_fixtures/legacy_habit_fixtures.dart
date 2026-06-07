import 'dart:convert';

import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/data/enums/habit_state.dart';

/// Builders for legacy storage payloads consumed by the migration tests.
/// Output shapes mirror the real `Habit.toJson` output so the migration runner
/// reads them through the same code path it would in production.
///
/// IMPORTANT — realistic shape: legacy `moveMonthHabits` calls `addHabit`,
/// which stamps a fresh `id` and `createdDate = today` on every month-copy
/// of a logical habit. The fixtures here mirror that: each month-copy gets a
/// distinct `id` and a `createdDate` set to the first day of that month.
/// The §12.8 dedup test relies on this shape — without it the test passes
/// for the wrong reason.
class LegacyHabitFixtures {
  /// Three-month seed:
  ///   - "Walk" (Mon/Wed/Fri, created Apr 1) appears in Apr / May / Jun ->
  ///     dedupes to a single ScheduledItem with combined completion log.
  ///     Each month-copy has a distinct `id` and a distinct `createdDate`
  ///     (the first of its month) to mirror real `moveMonthHabits` output.
  ///   - "Stretch" (Tue/Thu, created May 10) appears in May / Jun -> dedupes
  ///     to one item, same realistic shape.
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
      id: 'WALK0002',
      name: 'Walk',
      createdDate: DateTime(2026, 5, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{
        4: HabitState.DONE,
        6: HabitState.SUSPENDED,
        8: HabitState.DONE,
      },
    );
    final walkJun = Habit(
      id: 'WALK0003',
      name: 'Walk',
      createdDate: DateTime(2026, 6, 1),
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
      id: 'STRETCH2',
      name: 'Stretch',
      createdDate: DateTime(2026, 6, 1),
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

  /// Two same-name habits in different months with **different weekday sets**.
  /// Used by the §12.8 "stay separate" test:
  ///   - "Workout" Mon/Wed/Fri in Jan/Feb/Mar 2026
  ///   - "Workout" Tue/Thu in Jun 2026
  /// Each month-copy of the first habit has a distinct id + createdDate
  /// (mirroring `moveMonthHabits`).
  static Map<String, String> twoWorkoutsDifferentWeekdays() {
    final workoutJan = Habit(
      id: 'WORKOUT_JAN',
      name: 'Workout',
      createdDate: DateTime(2026, 1, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{5: HabitState.DONE},
    );
    final workoutFeb = Habit(
      id: 'WORKOUT_FEB',
      name: 'Workout',
      createdDate: DateTime(2026, 2, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{4: HabitState.DONE},
    );
    final workoutMar = Habit(
      id: 'WORKOUT_MAR',
      name: 'Workout',
      createdDate: DateTime(2026, 3, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{6: HabitState.NOT_DONE},
    );
    final workoutJun = Habit(
      id: 'WORKOUT_JUN',
      name: 'Workout',
      createdDate: DateTime(2026, 6, 1),
      repeatDays: <String>['Tuesday', 'Thursday'],
      daysStates: <int, HabitState>{
        2: HabitState.DONE,
        4: HabitState.NOT_DONE,
      },
    );
    return {
      '${AppLocalStorageKeys.habitMonth}2026-1': _encode([workoutJan]),
      '${AppLocalStorageKeys.habitMonth}2026-2': _encode([workoutFeb]),
      '${AppLocalStorageKeys.habitMonth}2026-3': _encode([workoutMar]),
      '${AppLocalStorageKeys.habitMonth}2026-6': _encode([workoutJun]),
    };
  }

  /// Same habit "Read" appears in Apr with `repeatDays = [Monday, Wednesday,
  /// Friday]` and in May with `repeatDays = [Friday, Monday, Wednesday]`
  /// (identical set, different list order). Used by the §12.8 "repeatDays
  /// order does not affect dedup" test.
  static Map<String, String> sameWeekdaySetDifferentOrder() {
    final readApr = Habit(
      id: 'READ_APR',
      name: 'Read',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{7: HabitState.DONE},
    );
    final readMay = Habit(
      id: 'READ_MAY',
      name: 'Read',
      createdDate: DateTime(2026, 5, 1),
      // Same set, different order — exercises the sort canonicalization.
      repeatDays: <String>['Friday', 'Monday', 'Wednesday'],
      daysStates: <int, HabitState>{8: HabitState.NOT_DONE},
    );
    return {
      '${AppLocalStorageKeys.habitMonth}2026-4': _encode([readApr]),
      '${AppLocalStorageKeys.habitMonth}2026-5': _encode([readMay]),
    };
  }

  /// Mid-life weekday-set edit: habit "Gym" was Mon/Wed/Fri in Apr/May and
  /// then Mon/Wed/Fri/Sat in Jun (user edited weekdays in June). Per §11.7
  /// this is a deliberate split — migration produces TWO items.
  static Map<String, String> midLifeWeekdayEdit() {
    final gymApr = Habit(
      id: 'GYM_APR',
      name: 'Gym',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{6: HabitState.DONE},
    );
    final gymMay = Habit(
      id: 'GYM_MAY',
      name: 'Gym',
      createdDate: DateTime(2026, 5, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{4: HabitState.DONE},
    );
    final gymJun = Habit(
      id: 'GYM_JUN',
      name: 'Gym',
      createdDate: DateTime(2026, 6, 1),
      // User added Saturday in June.
      repeatDays: <String>['Monday', 'Wednesday', 'Friday', 'Saturday'],
      daysStates: <int, HabitState>{
        6: HabitState.DONE,
        13: HabitState.DONE,
      },
    );
    return {
      '${AppLocalStorageKeys.habitMonth}2026-4': _encode([gymApr]),
      '${AppLocalStorageKeys.habitMonth}2026-5': _encode([gymMay]),
      '${AppLocalStorageKeys.habitMonth}2026-6': _encode([gymJun]),
    };
  }

  /// Per-cell conflict scenario: same dedup key (same name + same weekdays)
  /// across Apr and May, both with a `daysStates[15]` entry. The Apr value is
  /// DONE; the May value is NOT_DONE. Since they belong to different month
  /// keys, the resulting ISO dates are different ("2026-04-15" vs
  /// "2026-05-15") — but this fixture covers the case where someone
  /// hand-edited the prefs and the May blob carries the same iso-date as Apr.
  /// We model that by putting day 15 in BOTH blobs under their own months;
  /// the test asserts merged log has both ISO dates, with the May entry
  /// matching its (newer) state.
  ///
  /// To actually exercise per-cell last-write-wins on the same ISO date we
  /// also include a deliberate iso-date collision: day 1 in May (yielding
  /// 2026-05-01) AND day 1 in May again in a synthetic second record under
  /// the same month key — impossible from `moveMonthHabits` but constructable
  /// by hand. We fold both into the same month blob to ensure the runner
  /// sees them in order.
  static Map<String, String> perCellConflict() {
    final ridgeApr = Habit(
      id: 'RIDGE_APR',
      name: 'Ridge',
      createdDate: DateTime(2026, 4, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{15: HabitState.DONE},
    );
    final ridgeMay = Habit(
      id: 'RIDGE_MAY',
      name: 'Ridge',
      createdDate: DateTime(2026, 5, 1),
      repeatDays: <String>['Monday', 'Wednesday', 'Friday'],
      daysStates: <int, HabitState>{15: HabitState.NOT_DONE},
    );
    return {
      '${AppLocalStorageKeys.habitMonth}2026-4': _encode([ridgeApr]),
      '${AppLocalStorageKeys.habitMonth}2026-5': _encode([ridgeMay]),
    };
  }

  static String _encode(List<Habit> habits) {
    return jsonEncode(habits.map((h) => h.toJson()).toList());
  }
}
