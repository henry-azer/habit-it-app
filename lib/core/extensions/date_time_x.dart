/// DateTime extensions used across feature code.
extension DateTimeX on DateTime {
  /// Same calendar date (ignoring time-of-day).
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Same calendar month.
  bool isInSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  /// `YYYY-M` (no zero-pad — matches legacy SharedPreferences month key shape).
  String get monthKey => '$year-$month';

  /// `YYYY-M-D` (no zero-pad — matches legacy day-init key shape).
  String get dateKey => '$year-$month-$day';

  /// English weekday name (`Monday`..`Sunday`) — matches the legacy
  /// `Day` enum's `.value` strings used in `Habit.repeatDays`.
  String get weekdayName {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday - 1];
  }
}
