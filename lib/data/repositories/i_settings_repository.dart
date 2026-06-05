import '../entities/habit_schedule.dart';
import '../entities/settings_model.dart';
import '../../core/utils/result.dart';

abstract class ISettingsRepository {
  Stream<SettingsModel> watch();
  Future<Result<SettingsModel>> get();

  Future<Result<void>> updateThemeMode(String mode);
  Future<Result<void>> updateAccentColor(String hex);
  Future<Result<void>> updateLocale(String? code);
  Future<Result<void>> updateNotificationsEnabled(bool v);
  Future<Result<void>> updateDailySummary({required bool enabled, required String hhmm});
  Future<Result<void>> updateDefaultSchedule(HabitSchedule schedule);
  Future<Result<void>> updateDefaultReminderHhmm(String? hhmm);
  Future<Result<void>> updateBiometricEnabled(bool v);
  Future<Result<void>> updateAiEnabled(bool v);
  Future<Result<void>> updateAiModel(String modelId);
  Future<Result<void>> updateDefaultLanding(LandingMode mode);
  Future<Result<void>> markCoachPrivacyAcknowledged();
}
