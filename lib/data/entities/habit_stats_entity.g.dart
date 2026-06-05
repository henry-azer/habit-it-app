// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_stats_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitStatsEntity _$HabitStatsEntityFromJson(Map<String, dynamic> json) =>
    _HabitStatsEntity(
      done: (json['done'] as num).toInt(),
      notDone: (json['notDone'] as num).toInt(),
      created: (json['created'] as num).toInt(),
      suspended: (json['suspended'] as num).toInt(),
      inProgress: (json['inProgress'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HabitStatsEntityToJson(_HabitStatsEntity instance) =>
    <String, dynamic>{
      'done': instance.done,
      'notDone': instance.notDone,
      'created': instance.created,
      'suspended': instance.suspended,
      'inProgress': instance.inProgress,
    };
