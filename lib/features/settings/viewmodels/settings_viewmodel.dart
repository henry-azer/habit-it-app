import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/settings_model.dart';
import '../../../data/repositories/i_settings_repository.dart';
import '../../../data/repositories/i_user_repository.dart';
import '../../../data/entities/user_entity.dart';

/// SET-002 — shared ViewModel for the Settings hub and most sub-screens.
/// Reference template lifted from Padlock; only the load + dispose surface
/// is wired here, per-row mutations land with each SET-* story.
class SettingsViewModel {
  SettingsViewModel({
    ISettingsRepository? settingsRepo,
    IUserRepository? userRepo,
  })  : _settingsRepo = settingsRepo ?? getIt<ISettingsRepository>(),
        _userRepo = userRepo ?? getIt<IUserRepository>();

  final ISettingsRepository _settingsRepo;
  final IUserRepository _userRepo;

  final BehaviorSubject<SettingsModel> settings$ =
      BehaviorSubject.seeded(SettingsModel.defaults());
  final BehaviorSubject<UserEntity> user$ =
      BehaviorSubject.seeded(UserEntity.defaults());

  Future<void> load() async {
    final s = await _settingsRepo.get();
    s.when(
      ok: (m) {
        if (!settings$.isClosed) settings$.add(m);
      },
      err: (_) {},
    );
    final u = await _userRepo.get();
    u.when(
      ok: (m) {
        if (!user$.isClosed) user$.add(m);
      },
      err: (_) {},
    );
  }

  Future<void> updateThemeMode(String mode) => _settingsRepo.updateThemeMode(mode);
  Future<void> updateAccentColor(String hex) => _settingsRepo.updateAccentColor(hex);
  Future<void> updateLocale(String? code) => _settingsRepo.updateLocale(code);
  Future<void> updateNotificationsEnabled(bool v) =>
      _settingsRepo.updateNotificationsEnabled(v);

  void dispose() {
    settings$.close();
    user$.close();
  }
}
