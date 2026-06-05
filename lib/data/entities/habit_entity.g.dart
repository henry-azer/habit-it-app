// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitEntity _$HabitEntityFromJson(Map<String, dynamic> json) => _HabitEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  createdDate: DateTime.parse(json['createdDate'] as String),
  schedule: const _HabitScheduleConverter().fromJson(
    json['schedule'] as Map<String, dynamic>,
  ),
  daysStates: json['daysStates'] == null
      ? const <int, HabitState>{}
      : const _HabitStateMapConverter().fromJson(
          json['daysStates'] as Map<String, dynamic>,
        ),
  progress:
      (json['progress'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ) ??
      const <int, int>{},
  reminder: json['reminder'] == null
      ? null
      : HabitReminder.fromJson(json['reminder'] as Map<String, dynamic>),
  target: json['target'] == null
      ? null
      : HabitTarget.fromJson(json['target'] as Map<String, dynamic>),
  categoryId: json['categoryId'] as String?,
  noteIds:
      (json['noteIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  sortIndex: (json['sortIndex'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HabitEntityToJson(_HabitEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdDate': instance.createdDate.toIso8601String(),
      'schedule': const _HabitScheduleConverter().toJson(instance.schedule),
      'daysStates': const _HabitStateMapConverter().toJson(instance.daysStates),
      'progress': instance.progress.map((k, e) => MapEntry(k.toString(), e)),
      'reminder': instance.reminder,
      'target': instance.target,
      'categoryId': instance.categoryId,
      'noteIds': instance.noteIds,
      'sortIndex': instance.sortIndex,
    };
