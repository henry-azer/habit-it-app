class DayInWeek {
  String dayName;
  String dayKey;
  bool isSelected = false;

  DayInWeek(this.dayName, {required this.dayKey, this.isSelected = false});

  void toggleIsSelected() {
    isSelected = !isSelected;
  }

  static List<DayInWeek> getWeekDaysBySelectedDays(List<String> selectedDays) {
    return [
      DayInWeek('Monday', dayKey: 'MON', isSelected: selectedDays.contains('Monday')),
      DayInWeek('Tuesday', dayKey: 'TUE', isSelected: selectedDays.contains('Tuesday')),
      DayInWeek('Wednesday', dayKey: 'WED', isSelected: selectedDays.contains('Wednesday')),
      DayInWeek('Thursday', dayKey: 'THU', isSelected: selectedDays.contains('Thursday')),
      DayInWeek('Friday', dayKey: 'FRI', isSelected: selectedDays.contains('Friday')),
      DayInWeek('Saturday', dayKey: 'SAT', isSelected: selectedDays.contains('Saturday')),
      DayInWeek('Sunday', dayKey: 'SUN', isSelected: selectedDays.contains('Sunday')),
    ];
  }

  static List<DayInWeek> getWeekDays() {
    return [
      DayInWeek('Monday', dayKey: 'MON'),
      DayInWeek('Tuesday', dayKey: 'TUE'),
      DayInWeek('Wednesday', dayKey: 'WED'),
      DayInWeek('Thursday', dayKey: 'THU'),
      DayInWeek('Friday', dayKey: 'FRI'),
      DayInWeek('Saturday', dayKey: 'SAT'),
      DayInWeek('Sunday', dayKey: 'SUN'),
    ];
  }

  static String getDayKeyByName(String dayName) {
    var weekDays = getWeekDays();
    for (var day in weekDays) {
      if (day.dayName.toLowerCase() == dayName.toLowerCase()) {
        return day.dayKey;
      }
    }
    return "";
  }

  static List<DayInWeek> map(List<String> strings) {
    List<DayInWeek> days = [];
    for (var day in strings) {
      DayInWeek(day, dayKey: getDayKeyByName(day), isSelected: true);
    }
    return days;
  }
}
