/// AUTHOR: Henry Azer
/// DATE: 23-10-2023
/// UTIL: DATE UTIL
class DateUtil {

  /// Now Date
  static DateTime now = DateTime.now();

  /// Getters
  static DateTime getTodayDate() {
    return DateTime(now.year, now.month, now.day, 0);
  }

  static DateTime getFirstDayOfCurrentMonth() {
    return DateTime(now.year, now.month, 1, 0);
  }

  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1, 0);
  }

  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 0);
  }

  static List<DateTime> getCurrentMonthDays() {
    DateTime now = DateTime.now();
    List<DateTime> monthDaysList = [];
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1, 0);
    DateTime todayDate = DateTime(now.year, now.month, now.day, 0);

    for (int i = 0; i < todayDate.day; i++) {
      DateTime currentDay = firstDayOfCurrentMonth.add(Duration(days: i));
      monthDaysList.add(DateTime(currentDay.year, currentDay.month, currentDay.day, 0));
    }

    return monthDaysList.reversed.toList();
  }

  static List<DateTime> getMonthDaysUntil(DateTime date) {
    DateTime firstDayOfCurrentMonth = DateTime(date.year, date.month, 1, 0);
    List<DateTime> monthDaysList = [];

    for (int i = 0; i < date.day; i++) {
      DateTime currentDay = firstDayOfCurrentMonth.add(Duration(days: i));
      monthDaysList.add(DateTime(currentDay.year, currentDay.month, currentDay.day, 0));
    }

    return monthDaysList.reversed.toList();
  }

  static String getCurrentMonthDateString() {
    return "${now.year}-${now.month}";
  }

  static String getCurrentDateString() {
    return "${now.year}-${now.month}-${now.day}";
  }

  /// Convert Date to String
  static String convertDateToString(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static String convertDateToMonthString(DateTime date) {
    return "${date.year}-${date.month}";
  }

  /// Convert String to Date
  static DateTime convertStringToDate(String date) {
    List<String> parts = date.split("-");
    if (parts.length == 3) {
      int? year = int.tryParse(parts[0]);
      int? month = int.tryParse(parts[1]);
      int? day = int.tryParse(parts[2]);
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day, 0);
      }
    }
    return now;
  }

  static DateTime convertMonthStringToDate(String date) {
    List<String> parts = date.split("-");
    if (parts.length == 2) {
      int? year = int.tryParse(parts[0]);
      int? month = int.tryParse(parts[1]);
      if (year != null && month != null) {
        return DateTime(year, month, 1, 0);
      }
    }
    return now;
  }

  /// Calculations
  static int countDaysOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final lastDayOfCurrentMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  static int countDaysOfMonthUntilToday(DateTime date) {
    return DateTime.now().add(const Duration(days: 1)).difference(date).inDays;
  }
}