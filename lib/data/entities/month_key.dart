/// Identifies a calendar month: year + 1..12 month, formatted `YYYY-M` to
/// match the legacy SharedPreferences key shape (no zero-padding).
class MonthKey {
  const MonthKey(this.year, this.month);

  factory MonthKey.fromDateTime(DateTime d) => MonthKey(d.year, d.month);

  factory MonthKey.parse(String key) {
    final parts = key.split('-');
    if (parts.length != 2) {
      throw FormatException('Invalid MonthKey: $key');
    }
    return MonthKey(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int year;
  final int month;

  /// Storage representation `YYYY-M` (no leading zero on month).
  String get key => '$year-$month';

  @override
  String toString() => key;

  @override
  bool operator ==(Object other) =>
      other is MonthKey && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}
