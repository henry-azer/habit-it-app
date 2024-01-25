import '../../data/enums/day.dart';

/// AUTHOR: Henry Azer
/// DATE: 23-10-2023
/// UTIL: DATE UTIL
class DateUtil {
  /// Now Date
  static DateTime now = DateTime.now();

  /// Getters
  static DateTime getDateByDay(int day) {
    return DateTime(now.year, now.month, day, 0);
  }

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
      monthDaysList
          .add(DateTime(currentDay.year, currentDay.month, currentDay.day, 0));
    }

    return monthDaysList.reversed.toList();
  }

  static List<DateTime> getMonthDaysUntil(DateTime date) {
    DateTime firstDayOfCurrentMonth = DateTime(date.year, date.month, 1, 0);
    List<DateTime> monthDaysList = [];

    for (int i = 0; i < date.day; i++) {
      DateTime currentDay = firstDayOfCurrentMonth.add(Duration(days: i));
      monthDaysList
          .add(DateTime(currentDay.year, currentDay.month, currentDay.day, 0));
    }

    return monthDaysList.reversed.toList();
  }

  static String getPreviousMonthDateString(DateTime date) {
    DateTime previousMonth = DateTime(date.year, date.month - 1, date.day);
    return "${previousMonth.year}-${previousMonth.month}";
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
    try {
      return DateTime.parse(date);
    } catch (ignore) {}
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
    final todayDate = getTodayDate();
    if (todayDate.month == date.month) return todayDate.day;

    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final lastDayOfCurrentMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  static int countDaysOfMonthUntilToday(DateTime date) {
    return DateTime.now().add(const Duration(days: 1)).difference(date).inDays;
  }

  static bool isDateInRange(DateTime checkDate, DateTime startMonth, DateTime endMonth) {
    return (checkDate.isAfter(startMonth) || checkDate.isAtSameMomentAs(startMonth)) && (checkDate.isBefore(endMonth) || checkDate.isAtSameMomentAs(endMonth));
  }

  /// Today Name
  static String getDateDayName(DateTime date) {
    Day? today;
    switch (date.weekday) {
      case 1:
        today = Day.Monday;
        break;
      case 2:
        today = Day.Tuesday;
        break;
      case 3:
        today = Day.Wednesday;
        break;
      case 4:
        today = Day.Thursday;
        break;
      case 5:
        today = Day.Friday;
        break;
      case 6:
        today = Day.Saturday;
        break;
      case 7:
        today = Day.Sunday;
        break;
      default:
        today = null;
    }
    return today?.value ?? 'Unknown';
  }

  /// CALCULATE DAYS COUNT
  static int countDaysOfWeekSinceDate(List<String> days, DateTime date) {
    int totalCount = 0;
    DateTime currentDate = DateUtil.getTodayDate();

    for (var day in days) {
      int differenceInDays = currentDate.difference(date).inDays;

      int count = 0;
      for (int i = 0; i <= differenceInDays; i++) {
        DateTime currentDay = date.add(Duration(days: i));
        if (currentDay.weekday == getDayOfWeekNumber(day)) {
          count++;
        }
      }

      totalCount += count;
    }

    return totalCount;
  }

  static int getDayOfWeekNumber(String dayOfWeek) {
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        throw Exception('Invalid day of the week provided.');
    }
  }

  static String getDayOfWeekName(DateTime date) {
    int weekday = date.weekday;

    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        throw Exception('Unexpected weekday value: $weekday');
    }
  }
}
