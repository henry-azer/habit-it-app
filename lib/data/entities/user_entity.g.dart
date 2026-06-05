// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  id: json['id'] as String? ?? '',
  username: json['username'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  password: json['password'] as String?,
  isRegistered: json['isRegistered'] as bool? ?? false,
  isAuthenticated: json['isAuthenticated'] as bool? ?? false,
  isPINAuthenticated: json['isPINAuthenticated'] as bool? ?? false,
  isBiometricAuthenticated: json['isBiometricAuthenticated'] as bool? ?? false,
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'gender': instance.gender,
      'password': instance.password,
      'isRegistered': instance.isRegistered,
      'isAuthenticated': instance.isAuthenticated,
      'isPINAuthenticated': instance.isPINAuthenticated,
      'isBiometricAuthenticated': instance.isBiometricAuthenticated,
    };
