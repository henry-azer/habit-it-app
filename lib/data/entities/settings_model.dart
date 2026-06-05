import 'package:freezed_annotation/freezed_annotation.dart';

import 'habit_schedule.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

enum LandingMode {
  habits, // legacy default
  todayAgenda,
}

/// User-configurable settings (SET-002 onwards). One blob per user.
///
/// PO G-001: `accentColorHex` default is `#00A36C` (green), not slate.
@freezed
sealed class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default('system') String themeMode, // 'system' | 'light' | 'dark'
    @Default('#00A36C') String accentColorHex,
    String? localeCode, // null → system
    @Default(true) bool notificationsEnabled,
    @Default(false) bool dailySummaryEnabled,
    @Default('08:00') String dailySummaryHhmm,
    @_HabitScheduleConverter()
    @Default(HabitSchedule.daily())
    HabitSchedule defaultSchedule,
    String? defaultReminderHhmm,
    @Default(false) bool biometricEnabled,
    @Default(false) bool aiEnabled,
    @Default('llama-3.3-70b-versatile') String aiModel,
    @Default(LandingMode.habits) LandingMode defaultLanding,
    @Default(false) bool coachPrivacyAcknowledged,
  }) = _SettingsModel;

  factory SettingsModel.defaults() => const SettingsModel();

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}

class _HabitScheduleConverter
    implements JsonConverter<HabitSchedule, Map<String, dynamic>> {
  const _HabitScheduleConverter();

  @override
  HabitSchedule fromJson(Map<String, dynamic> json) =>
      HabitSchedule.fromJson(json);

  @override
  Map<String, dynamic> toJson(HabitSchedule object) => object.toJson();
}
