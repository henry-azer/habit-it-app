// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      themeMode: json['themeMode'] as String? ?? 'system',
      accentColorHex: json['accentColorHex'] as String? ?? '#00A36C',
      localeCode: json['localeCode'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailySummaryEnabled: json['dailySummaryEnabled'] as bool? ?? false,
      dailySummaryHhmm: json['dailySummaryHhmm'] as String? ?? '08:00',
      defaultSchedule: json['defaultSchedule'] == null
          ? const HabitSchedule.daily()
          : const _HabitScheduleConverter().fromJson(
              json['defaultSchedule'] as Map<String, dynamic>,
            ),
      defaultReminderHhmm: json['defaultReminderHhmm'] as String?,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      aiEnabled: json['aiEnabled'] as bool? ?? false,
      aiModel: json['aiModel'] as String? ?? 'llama-3.3-70b-versatile',
      defaultLanding:
          $enumDecodeNullable(_$LandingModeEnumMap, json['defaultLanding']) ??
          LandingMode.habits,
      coachPrivacyAcknowledged:
          json['coachPrivacyAcknowledged'] as bool? ?? false,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'accentColorHex': instance.accentColorHex,
      'localeCode': instance.localeCode,
      'notificationsEnabled': instance.notificationsEnabled,
      'dailySummaryEnabled': instance.dailySummaryEnabled,
      'dailySummaryHhmm': instance.dailySummaryHhmm,
      'defaultSchedule': const _HabitScheduleConverter().toJson(
        instance.defaultSchedule,
      ),
      'defaultReminderHhmm': instance.defaultReminderHhmm,
      'biometricEnabled': instance.biometricEnabled,
      'aiEnabled': instance.aiEnabled,
      'aiModel': instance.aiModel,
      'defaultLanding': _$LandingModeEnumMap[instance.defaultLanding]!,
      'coachPrivacyAcknowledged': instance.coachPrivacyAcknowledged,
    };

const _$LandingModeEnumMap = {
  LandingMode.habits: 'habits',
  LandingMode.todayAgenda: 'todayAgenda',
};
