import '../entities/habit.dart';
import '../entities/month_key.dart';
import '../enums/habit_state.dart';
import '../../core/utils/result.dart';

/// Habit repository (FND-002).
///
/// Note: For Foundation, the contract uses the legacy [Habit] class so the
/// migrated screens continue to work with no churn. The Freezed `HabitEntity`
/// is the canonical model going forward (FND-003); during the FND-006 follow-up
/// the existing screens get rewritten to consume `HabitEntity` and the
/// interface is widened accordingly.
abstract class IHabitRepository {
  Stream<List<Habit>> watchByMonth(MonthKey month);
  Future<Result<List<Habit>>> getByMonth(MonthKey month);
  Future<Result<List<Habit>>> getByDay(DateTime day);
  Future<Result<Habit?>> getById(String id, MonthKey month);

  Future<Result<void>> add({
    required String name,
    required List<String> repeatDays,
    required MonthKey month,
  });

  Future<Result<void>> update(Habit habit, MonthKey month);
  Future<Result<void>> delete(Habit habit, MonthKey month);
  Future<Result<void>> reorder(Habit a, Habit b, MonthKey month);
  Future<Result<void>> toggle(Habit habit, int day, MonthKey month);
  Future<Result<void>> suspend(Habit habit, int day, MonthKey month);
  Future<Result<void>> unsuspend(Habit habit, int day, MonthKey month);

  /// Lazy roll-forward — initialise today's habit slots for a freshly-opened
  /// day. Idempotent; safe to call repeatedly.
  Future<Result<void>> initDayIfNeeded(DateTime day, MonthKey month);

  Future<bool> isMonthInit(MonthKey month);
  Future<Result<void>> moveMonth({
    required MonthKey from,
    required MonthKey to,
    required bool carryForward,
  });

  /// Direct state-setter used by the notification "Done" action (ENG-006).
  Future<Result<void>> setStateForDay({
    required String habitId,
    required int day,
    required MonthKey month,
    required HabitState state,
  });
}
