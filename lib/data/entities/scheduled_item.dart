import '../../core/utils/date_util.dart';
import '../enums/habit_state.dart';
import 'recurrence.dart';

/// Unified entity for any scheduled item — one-off todo, daily habit,
/// monthly bill, yearly anniversary, etc. See
/// `docs/scheduler/architecture.md` §2.
///
/// Identity is [id]. [completionLog] keys are ISO `yyyy-MM-dd` strings; values
/// are [HabitState] (reused per Story 1.1 requirement 3). [name], [recurrence]
/// and [carryOverEnabled] are mutable to support in-place edits inside the
/// datasource; [completionLog] is a `final` reference but its contents are
/// mutated by the datasource.
class ScheduledItem {
  final String id;
  String name;
  final DateTime createdDate;
  Recurrence recurrence;
  final Map<String, HabitState> completionLog;
  bool carryOverEnabled;

  ScheduledItem({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.recurrence,
    required this.completionLog,
    required this.carryOverEnabled,
  });

  /// Pure delegate to [Recurrence.occursOn].
  bool occursOn(DateTime date) => recurrence.occursOn(date);

  /// State of this item on [date]. Defaults to [HabitState.CREATED] when the
  /// log has no entry — matches the legacy "freshly initialized" semantics.
  HabitState stateOn(DateTime date) {
    return completionLog[DateUtil.isoDate(date)] ?? HabitState.CREATED;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdDate': createdDate.toIso8601String(),
    'recurrence': recurrence.toJson(),
    'completionLog': completionLog.map(
      (key, value) => MapEntry(key, value.index),
    ),
    'carryOverEnabled': carryOverEnabled,
  };

  factory ScheduledItem.fromJson(Map<String, dynamic> json) {
    final rawLog = Map<String, dynamic>.from(json['completionLog'] as Map);
    final log = <String, HabitState>{};
    rawLog.forEach((k, v) {
      log[k] = HabitState.values[v as int];
    });
    return ScheduledItem(
      id: json['id'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      recurrence: Recurrence.fromJson(
        Map<String, dynamic>.from(json['recurrence']),
      ),
      completionLog: log,
      carryOverEnabled: json['carryOverEnabled'] as bool,
    );
  }
}
