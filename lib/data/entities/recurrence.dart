import '../../core/utils/date_util.dart';
import '../enums/recurrence_kind.dart';

/// A single class representing any of the five recurrence flavors via a
/// [RecurrenceKind] discriminator plus nullable per-flavor fields. This
/// shape is required by Dart 2.18 (no `sealed`, no patterns) and chosen to
/// keep JSON serialization simple. See
/// `docs/scheduler/architecture.md` §2.1.
class Recurrence {
  final RecurrenceKind kind;

  // oneOff
  final DateTime? oneOffDate;

  // Common to every recurring flavor.
  final DateTime? startDate;

  // weekly — full English weekday names per [DateUtil.getDayOfWeekName].
  final List<String>? weekdays;

  // monthlyByDay
  final int? dayOfMonth;

  // yearly
  final int? yearlyMonth;
  final int? yearlyDay;

  const Recurrence._({
    required this.kind,
    this.oneOffDate,
    this.startDate,
    this.weekdays,
    this.dayOfMonth,
    this.yearlyMonth,
    this.yearlyDay,
  });

  // ---------------------------------------------------------------------------
  // Factories
  // ---------------------------------------------------------------------------

  factory Recurrence.oneOff(DateTime date) {
    return Recurrence._(
      kind: RecurrenceKind.oneOff,
      oneOffDate: _normalize(date),
    );
  }

  factory Recurrence.daily(DateTime startDate) {
    return Recurrence._(
      kind: RecurrenceKind.daily,
      startDate: _normalize(startDate),
    );
  }

  factory Recurrence.weekly(List<String> weekdays, DateTime startDate) {
    if (weekdays.isEmpty) {
      throw ArgumentError.value(
        weekdays,
        'weekdays',
        'weekly recurrence requires at least one weekday',
      );
    }
    const allowed = <String>{
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    };
    for (final w in weekdays) {
      if (!allowed.contains(w)) {
        throw ArgumentError.value(w, 'weekdays', 'must be one of $allowed');
      }
    }
    return Recurrence._(
      kind: RecurrenceKind.weekly,
      startDate: _normalize(startDate),
      weekdays: List<String>.unmodifiable(weekdays),
    );
  }

  factory Recurrence.monthlyByDay(int dayOfMonth, DateTime startDate) {
    if (dayOfMonth < 1 || dayOfMonth > 31) {
      throw ArgumentError.value(dayOfMonth, 'dayOfMonth', 'must be in [1, 31]');
    }
    return Recurrence._(
      kind: RecurrenceKind.monthlyByDay,
      startDate: _normalize(startDate),
      dayOfMonth: dayOfMonth,
    );
  }

  factory Recurrence.yearly(int month, int day, DateTime startDate) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be in [1, 12]');
    }
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'must be in [1, 31]');
    }
    // Reject (month, day) pairs that cannot occur in any year (e.g. Feb 30,
    // Apr 31). Leap-day (2, 29) is intentionally allowed at construction;
    // [occursOn] skips non-leap years.
    const maxDays = <int, int>{
      1: 31,
      2: 29,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31,
    };
    if (day > maxDays[month]!) {
      throw ArgumentError(
        'yearly recurrence: ($month, $day) is not a valid calendar date',
      );
    }
    return Recurrence._(
      kind: RecurrenceKind.yearly,
      startDate: _normalize(startDate),
      yearlyMonth: month,
      yearlyDay: day,
    );
  }

  // ---------------------------------------------------------------------------
  // Resolution
  // ---------------------------------------------------------------------------

  /// Returns whether this recurrence triggers on [date]. Pure — no I/O, no
  /// `DateTime.now()`. The date is normalized to midnight internally.
  /// Algorithm: `docs/scheduler/architecture.md` §3.
  bool occursOn(DateTime date) {
    final d = _normalize(date);
    switch (kind) {
      case RecurrenceKind.oneOff:
        return d == _normalize(oneOffDate!);

      case RecurrenceKind.daily:
        final s = _normalize(startDate!);
        return !d.isBefore(s);

      case RecurrenceKind.weekly:
        final s = _normalize(startDate!);
        if (d.isBefore(s)) return false;
        return weekdays!.contains(DateUtil.getDayOfWeekName(d));

      case RecurrenceKind.monthlyByDay:
        final s = _normalize(startDate!);
        // Start-month is inclusive; anything before its 1st is rejected.
        if (d.isBefore(DateTime(s.year, s.month, 1))) return false;
        final daysInThisMonth = DateUtil.daysInMonth(d.year, d.month);
        if (dayOfMonth! > daysInThisMonth) return false;
        if (d.day != dayOfMonth) return false;
        // First occurrence may be next month if start-day is after target day.
        if (d.year == s.year && d.month == s.month && dayOfMonth! < s.day) {
          return false;
        }
        return true;

      case RecurrenceKind.yearly:
        final s = _normalize(startDate!);
        if (d.isBefore(s)) return false;
        if (d.month != yearlyMonth) return false;
        if (d.day != yearlyDay) return false;
        if (yearlyMonth == 2 && yearlyDay == 29) {
          return DateUtil.isLeapYear(d.year);
        }
        return true;
    }
  }

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'kind': kind.jsonName};
    if (oneOffDate != null) {
      json['oneOffDate'] = oneOffDate!.toIso8601String();
    }
    if (startDate != null) {
      json['startDate'] = startDate!.toIso8601String();
    }
    if (weekdays != null) {
      json['weekdays'] = weekdays;
    }
    if (dayOfMonth != null) {
      json['dayOfMonth'] = dayOfMonth;
    }
    if (yearlyMonth != null) {
      json['yearlyMonth'] = yearlyMonth;
    }
    if (yearlyDay != null) {
      json['yearlyDay'] = yearlyDay;
    }
    return json;
  }

  factory Recurrence.fromJson(Map<String, dynamic> json) {
    final kind = RecurrenceKindCodec.fromJsonName(json['kind'] as String);
    DateTime? parseDate(Object? raw) =>
        raw == null ? null : DateTime.parse(raw as String);

    switch (kind) {
      case RecurrenceKind.oneOff:
        return Recurrence.oneOff(parseDate(json['oneOffDate'])!);
      case RecurrenceKind.daily:
        return Recurrence.daily(parseDate(json['startDate'])!);
      case RecurrenceKind.weekly:
        return Recurrence.weekly(
          (json['weekdays'] as List<dynamic>).cast<String>(),
          parseDate(json['startDate'])!,
        );
      case RecurrenceKind.monthlyByDay:
        return Recurrence.monthlyByDay(
          json['dayOfMonth'] as int,
          parseDate(json['startDate'])!,
        );
      case RecurrenceKind.yearly:
        return Recurrence.yearly(
          json['yearlyMonth'] as int,
          json['yearlyDay'] as int,
          parseDate(json['startDate'])!,
        );
    }
  }

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);
}
