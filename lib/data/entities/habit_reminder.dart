import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_reminder.freezed.dart';
part 'habit_reminder.g.dart';

/// Optional reminder for a habit (SCH-002).
@freezed
sealed class HabitReminder with _$HabitReminder {
  const factory HabitReminder({
    /// "HH:mm" 24-hour time, e.g. `08:00`.
    required String hhmm,
    @Default(true) bool enabled,
  }) = _HabitReminder;

  factory HabitReminder.fromJson(Map<String, dynamic> json) =>
      _$HabitReminderFromJson(json);
}
