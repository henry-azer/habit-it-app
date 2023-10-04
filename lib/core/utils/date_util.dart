/// AUTHOR: Henry Azer
/// DATE: 23-10-2023
/// UTIL: DATE UTIL
class DateUtil {

  /// Now Date
  static DateTime now = DateTime.now();

  /// Getters
  static DateTime getTodayDate() {
    return DateTime(now.year, now.month, now.day + 5, 0);
  }

  static DateTime getFirstDayOfCurrentMonth() {
    return DateTime(now.year, now.month, 1);
  }

  static List<DateTime> getCurrentMonthDays() {
    DateTime now = DateTime.now();
    List<DateTime> monthDaysList = [];
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1, 0);
    DateTime todayDate = DateTime(now.year, now.month, now.day, 0);

    for (int i = 0; i < todayDate.day + 5; i++) {
      DateTime currentDay = firstDayOfCurrentMonth.add(Duration(days: i));
      monthDaysList.add(DateTime(currentDay.year, currentDay.month, currentDay.day, 0));
    }

    return monthDaysList.reversed.toList();
  }

  /// Convert Date to String
  static String convertDateToDayString(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static String convertDateToMonthString(DateTime date) {
    return "${date.year}-${date.month}";
  }

  /// Convert String to Date
  static DateTime convertDayStringToDate(String date) {
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
        return DateTime(year, month, 0, 0);
      }
    }
    return now;
  }
}