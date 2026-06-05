import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../entities/habit.dart';
import '../../entities/month_key.dart';

/// Per-month habit storage backed by Hive.
///
/// Schema (TECHNICAL_STORIES.md §5):
/// - `month/<YYYY>-<M>`        → `List<Map>` (per-habit JSON)
/// - `month_init/<YYYY>-<M>`   → `bool`
/// - `day_init/<YYYY>-<M>-<D>` → `bool`
class HiveHabitSource {
  Box get _box => Hive.box(HiveBoxKeys.habits);

  String _monthKey(MonthKey m) => '${HiveBoxKeys.habitMonthPrefix}${m.key}';
  String _monthInitKey(MonthKey m) => '${HiveBoxKeys.habitMonthInitPrefix}${m.key}';
  String _dayInitKey(DateTime d) =>
      '${HiveBoxKeys.habitDayInitPrefix}${d.year}-${d.month}-${d.day}';

  Future<List<Habit>> getMonth(MonthKey month) async {
    final raw = _box.get(_monthKey(month));
    if (raw == null) return [];
    final list = (raw as List).cast<dynamic>();
    return list
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> putMonth(MonthKey month, List<Habit> habits) async {
    await _box.put(
      _monthKey(month),
      habits.map((h) => h.toJson()).toList(),
    );
  }

  Future<bool> isMonthInit(MonthKey month) async {
    return (_box.get(_monthInitKey(month)) as bool?) ?? false;
  }

  Future<void> setMonthInit(MonthKey month, bool value) async {
    await _box.put(_monthInitKey(month), value);
  }

  Future<bool> isDayInit(DateTime day) async {
    return (_box.get(_dayInitKey(day)) as bool?) ?? false;
  }

  Future<void> setDayInit(DateTime day, bool value) async {
    await _box.put(_dayInitKey(day), value);
  }
}
