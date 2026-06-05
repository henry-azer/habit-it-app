import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'wireName')
// ignore_for_file: constant_identifier_names
enum Day {
  Monday('Monday'),
  Tuesday('Tuesday'),
  Wednesday('Wednesday'),
  Thursday('Thursday'),
  Friday('Friday'),
  Saturday('Saturday'),
  Sunday('Sunday');

  const Day(this.wireName);
  final String wireName;
}

extension DayExtension on Day {
  String get value => wireName;
}
