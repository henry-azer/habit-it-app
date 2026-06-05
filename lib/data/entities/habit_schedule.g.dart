// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDaily _$ScheduleDailyFromJson(Map<String, dynamic> json) =>
    ScheduleDaily($type: json['runtimeType'] as String?);

Map<String, dynamic> _$ScheduleDailyToJson(ScheduleDaily instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

ScheduleWeekly _$ScheduleWeeklyFromJson(Map<String, dynamic> json) =>
    ScheduleWeekly(
      weekdays: (json['weekdays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ScheduleWeeklyToJson(ScheduleWeekly instance) =>
    <String, dynamic>{
      'weekdays': instance.weekdays,
      'runtimeType': instance.$type,
    };

ScheduleMonthlyAny _$ScheduleMonthlyAnyFromJson(Map<String, dynamic> json) =>
    ScheduleMonthlyAny($type: json['runtimeType'] as String?);

Map<String, dynamic> _$ScheduleMonthlyAnyToJson(ScheduleMonthlyAny instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

ScheduleMonthlyOn _$ScheduleMonthlyOnFromJson(Map<String, dynamic> json) =>
    ScheduleMonthlyOn(
      daysOfMonth: (json['daysOfMonth'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ScheduleMonthlyOnToJson(ScheduleMonthlyOn instance) =>
    <String, dynamic>{
      'daysOfMonth': instance.daysOfMonth,
      'runtimeType': instance.$type,
    };

ScheduleOneTime _$ScheduleOneTimeFromJson(Map<String, dynamic> json) =>
    ScheduleOneTime(
      date: DateTime.parse(json['date'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ScheduleOneTimeToJson(ScheduleOneTime instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'runtimeType': instance.$type,
    };

ScheduleNone _$ScheduleNoneFromJson(Map<String, dynamic> json) =>
    ScheduleNone($type: json['runtimeType'] as String?);

Map<String, dynamic> _$ScheduleNoneToJson(ScheduleNone instance) =>
    <String, dynamic>{'runtimeType': instance.$type};
