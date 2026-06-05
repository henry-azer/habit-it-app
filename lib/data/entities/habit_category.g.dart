// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitCategory _$HabitCategoryFromJson(Map<String, dynamic> json) =>
    _HabitCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
    );

Map<String, dynamic> _$HabitCategoryToJson(_HabitCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
    };
