enum Day {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

extension DayExtension on Day {
  String get value {
    switch (this) {
      case Day.Monday:
        return 'Monday';
      case Day.Tuesday:
        return 'Tuesday';
      case Day.Wednesday:
        return 'Wednesday';
      case Day.Thursday:
        return 'Thursday';
      case Day.Friday:
        return 'Friday';
      case Day.Saturday:
        return 'Saturday';
      case Day.Sunday:
        return 'Sunday';
      default:
        return "";
    }
  }
}
