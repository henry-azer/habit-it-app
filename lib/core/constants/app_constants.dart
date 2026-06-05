/// Misc public constants used across features.
abstract final class AppConstants {
  AppConstants._();

  static const String appName = 'Habit It';

  /// Legacy SharedPreferences key prefixes. Retained as constants so the
  /// migrator can reference them once and clear them in one place.
  static const String legacyAppKey = 'APP/APP';
  static const String legacyUserKey = 'APP/USER';
  static const String legacyHabitMonthPrefix = 'APP/HABIT/MONTH/';
  static const String legacyHabitMonthInitPrefix = 'APP/HABIT/MONTH/INIT';
  static const String legacyHabitDayInitPrefix = 'APP/HABIT/INIT/';
}
