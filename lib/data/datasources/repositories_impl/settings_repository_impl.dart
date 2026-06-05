import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/habit_schedule.dart';
import '../../entities/settings_model.dart';
import '../../repositories/i_settings_repository.dart';
import '../hive/hive_settings_source.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  SettingsRepositoryImpl(this._source);
  final HiveSettingsSource _source;
  final BehaviorSubject<SettingsModel> _stream = BehaviorSubject<SettingsModel>();
  Future<void> _serial = Future.value();

  @override
  Stream<SettingsModel> watch() => _stream;

  @override
  Future<Result<SettingsModel>> get() async {
    try {
      final m = await _source.read();
      if (!_stream.isClosed && _stream.valueOrNull != m) _stream.add(m);
      return Ok(m);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  Future<Result<void>> _mutate(SettingsModel Function(SettingsModel) f) {
    final completer = Completer<Result<void>>();
    _serial = _serial.then((_) async {
      try {
        final current = await _source.read();
        final next = f(current);
        await _source.write(next);
        if (!_stream.isClosed) _stream.add(next);
        completer.complete(const Ok(null));
      } catch (e, st) {
        completer.complete(Err(StorageFailure(e.toString(), st)));
      }
    });
    return completer.future;
  }

  @override
  Future<Result<void>> updateThemeMode(String mode) =>
      _mutate((s) => s.copyWith(themeMode: mode));

  @override
  Future<Result<void>> updateAccentColor(String hex) =>
      _mutate((s) => s.copyWith(accentColorHex: hex));

  @override
  Future<Result<void>> updateLocale(String? code) =>
      _mutate((s) => s.copyWith(localeCode: code));

  @override
  Future<Result<void>> updateNotificationsEnabled(bool v) =>
      _mutate((s) => s.copyWith(notificationsEnabled: v));

  @override
  Future<Result<void>> updateDailySummary({
    required bool enabled,
    required String hhmm,
  }) =>
      _mutate((s) => s.copyWith(dailySummaryEnabled: enabled, dailySummaryHhmm: hhmm));

  @override
  Future<Result<void>> updateDefaultSchedule(HabitSchedule schedule) =>
      _mutate((s) => s.copyWith(defaultSchedule: schedule));

  @override
  Future<Result<void>> updateDefaultReminderHhmm(String? hhmm) =>
      _mutate((s) => s.copyWith(defaultReminderHhmm: hhmm));

  @override
  Future<Result<void>> updateBiometricEnabled(bool v) =>
      _mutate((s) => s.copyWith(biometricEnabled: v));

  @override
  Future<Result<void>> updateAiEnabled(bool v) =>
      _mutate((s) => s.copyWith(aiEnabled: v));

  @override
  Future<Result<void>> updateAiModel(String modelId) =>
      _mutate((s) => s.copyWith(aiModel: modelId));

  @override
  Future<Result<void>> updateDefaultLanding(LandingMode mode) =>
      _mutate((s) => s.copyWith(defaultLanding: mode));

  @override
  Future<Result<void>> markCoachPrivacyAcknowledged() =>
      _mutate((s) => s.copyWith(coachPrivacyAcknowledged: true));
}
