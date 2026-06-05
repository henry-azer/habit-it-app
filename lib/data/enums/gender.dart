import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'wireName')
enum Gender {
  male('male'),
  female('female');

  const Gender(this.wireName);
  final String wireName;

  String get value => this == male ? 'Male' : 'Female';
}

/// Backwards-compatible alias used by legacy screens.
final List<String> genders = ['Male', 'Female'];

extension GenderExtension on Gender {
  // [value] is on the enum itself; kept as an extension alias for legacy imports.
}
