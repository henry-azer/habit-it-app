// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitNote _$HabitNoteFromJson(Map<String, dynamic> json) => _HabitNote(
  habitId: json['habitId'] as String,
  date: DateTime.parse(json['date'] as String),
  text: json['text'] as String,
);

Map<String, dynamic> _$HabitNoteToJson(_HabitNote instance) =>
    <String, dynamic>{
      'habitId': instance.habitId,
      'date': instance.date.toIso8601String(),
      'text': instance.text,
    };
