import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_schedule.freezed.dart';
part 'habit_schedule.g.dart';

/// Habit recurrence rule (SCH-001).
///
/// Five variants:
/// - `daily`        — applies every calendar day.
/// - `weekly`       — applies on the listed weekday names (`Monday`..`Sunday`).
/// - `monthlyAny`   — once per month, any day.
/// - `monthlyOn`    — on specific days of the month (1..31).
/// - `oneTime`      — single dated occurrence.
/// - `none`         — never schedules; useful as a defensive default
///                    (PO G-002 — legacy habits with empty `repeatDays`).
@freezed
sealed class HabitSchedule with _$HabitSchedule {
  const HabitSchedule._();

  const factory HabitSchedule.daily() = ScheduleDaily;

  /// `weekdays` MUST be a subset of `Monday..Sunday`.
  const factory HabitSchedule.weekly({
    required List<String> weekdays,
  }) = ScheduleWeekly;

  const factory HabitSchedule.monthlyAny() = ScheduleMonthlyAny;

  const factory HabitSchedule.monthlyOn({
    required List<int> daysOfMonth,
  }) = ScheduleMonthlyOn;

  const factory HabitSchedule.oneTime({
    required DateTime date,
  }) = ScheduleOneTime;

  const factory HabitSchedule.none() = ScheduleNone;

  factory HabitSchedule.fromJson(Map<String, dynamic> json) =>
      _$HabitScheduleFromJson(json);

  /// Returns true if the schedule should produce an occurrence on [day].
  /// Note: `monthlyAny` is a *count* constraint not a *date* one (PO G-009);
  /// callers should evaluate against month-aggregate state, not this method.
  bool shouldShowOn(DateTime day) {
    return switch (this) {
      ScheduleDaily() => true,
      ScheduleWeekly(:final weekdays) => weekdays.contains(_weekdayName(day)),
      ScheduleMonthlyAny() => true,
      ScheduleMonthlyOn(:final daysOfMonth) => daysOfMonth.contains(day.day),
      ScheduleOneTime(:final date) =>
        date.year == day.year && date.month == day.month && date.day == day.day,
      ScheduleNone() => false,
    };
  }

  static String _weekdayName(DateTime d) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[d.weekday - 1];
  }
}
