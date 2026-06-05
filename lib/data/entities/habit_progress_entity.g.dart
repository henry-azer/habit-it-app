// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_progress_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitProgressEntity _$HabitProgressEntityFromJson(Map<String, dynamic> json) =>
    _HabitProgressEntity(
      habitId: json['habitId'] as String,
      day: (json['day'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$HabitProgressEntityToJson(
  _HabitProgressEntity instance,
) => <String, dynamic>{
  'habitId': instance.habitId,
  'day': instance.day,
  'count': instance.count,
};
