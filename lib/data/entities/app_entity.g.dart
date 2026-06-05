// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppEntity _$AppEntityFromJson(Map<String, dynamic> json) => _AppEntity(
  init: json['init'] as bool? ?? false,
  initDate: json['initDate'] as String? ?? '',
  lastDate: json['lastDate'] as String? ?? '',
  migratedV1: json['migratedV1'] as bool? ?? false,
);

Map<String, dynamic> _$AppEntityToJson(_AppEntity instance) =>
    <String, dynamic>{
      'init': instance.init,
      'initDate': instance.initDate,
      'lastDate': instance.lastDate,
      'migratedV1': instance.migratedV1,
    };
