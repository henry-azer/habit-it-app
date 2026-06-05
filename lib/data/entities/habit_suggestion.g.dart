// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitSuggestion _$HabitSuggestionFromJson(Map<String, dynamic> json) =>
    _HabitSuggestion(
      title: json['title'] as String,
      description: json['description'] as String,
      suggestedWeekdays:
          (json['suggestedWeekdays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$HabitSuggestionToJson(_HabitSuggestion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'suggestedWeekdays': instance.suggestedWeekdays,
    };
