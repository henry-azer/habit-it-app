import 'date_util.dart';

class AppLocalStorageKeys {
  static const String app = "APP/APP";
  static const String user = "APP/USER";

  /// HABIT
  // static const String habits = "APP/HABITS";

  /// HABIT
  static const String habit = "HABITS/";
  static const String habitInitializedMonth = "INIT_MONTH";
  static const String habits = "/HABIT/";
  static const String habitMonths = "HABITS/MONTHS";
  static const String isMonthInitialized = "/IS_INITIALIZED";

  static getHabitInitializedMonthKey() {
    return habit + habitInitializedMonth;
  }

  static getHabitKey(String name, String month, String day) {
    return "$habit$month$habit$day/$name";
  }

  static getCurrentMonthIsInitializedKey() {
    return habit + DateUtil.getCurrentMonthDateString() + isMonthInitialized;
  }

  static getMonthHabitsKey(String month) {
    return habit + month + habits;
  }
}
