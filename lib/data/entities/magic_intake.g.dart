// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_intake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MagicIntake _$MagicIntakeFromJson(Map<String, dynamic> json) => _MagicIntake(
  feelingText: json['feelingText'] as String,
  answers:
      (json['answers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$MagicIntakeToJson(_MagicIntake instance) =>
    <String, dynamic>{
      'feelingText': instance.feelingText,
      'answers': instance.answers,
    };
