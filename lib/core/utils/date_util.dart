class DateUtil {
  static DateTime now = DateTime.now();

  static String getCurrentMonthString() {
    return "${now.year}-${now.month}";
  }

  static String getCurrentDayString() {
    return "${now.year}-${now.month}-${now.day}";
  }

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

}