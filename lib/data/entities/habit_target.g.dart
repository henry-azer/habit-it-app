// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitTarget _$HabitTargetFromJson(Map<String, dynamic> json) => _HabitTarget(
  targetCount: (json['targetCount'] as num).toInt(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$HabitTargetToJson(_HabitTarget instance) =>
    <String, dynamic>{
      'targetCount': instance.targetCount,
      'unit': instance.unit,
    };
