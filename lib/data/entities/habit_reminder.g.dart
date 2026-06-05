// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitReminder _$HabitReminderFromJson(Map<String, dynamic> json) =>
    _HabitReminder(
      hhmm: json['hhmm'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$HabitReminderToJson(_HabitReminder instance) =>
    <String, dynamic>{'hhmm': instance.hhmm, 'enabled': instance.enabled};
