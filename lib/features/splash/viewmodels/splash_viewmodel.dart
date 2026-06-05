import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/app_routes.dart';
import '../../../data/repositories/i_app_repository.dart';
import '../../../data/repositories/i_user_repository.dart';

/// Splash screen state.
sealed class SplashUiState {
  const SplashUiState();
}

class SplashLoading extends SplashUiState {
  const SplashLoading();
}

class SplashNavigate extends SplashUiState {
  const SplashNavigate(this.targetPath);
  final String targetPath;
}

/// Splash ViewModel — decides where to route the user on app open.
///
/// Reference implementation of the FND-006 ViewModel contract: takes
/// repositories via constructor (default to `getIt<T>()`), exposes
/// `BehaviorSubject<T>` state stream, and disposes cleanly.
class SplashViewModel {
  SplashViewModel({
    IAppRepository? appRepo,
    IUserRepository? userRepo,
    Duration? splashDelay,
    DateTime Function()? now,
  })  : _appRepo = appRepo ?? getIt<IAppRepository>(),
        _userRepo = userRepo ?? getIt<IUserRepository>(),
        _splashDelay = splashDelay ?? const Duration(seconds: 1),
        _now = now ?? DateTime.now;

  final IAppRepository _appRepo;
  final IUserRepository _userRepo;
  final Duration _splashDelay;
  final DateTime Function() _now;

  final BehaviorSubject<SplashUiState> state$ =
      BehaviorSubject.seeded(const SplashLoading());

  Timer? _timer;

  /// Reads the app + user state, waits the splash delay, then emits a
  /// [SplashNavigate] event with the route target.
  Future<void> load() async {
    final appResult = await _appRepo.get();
    final userResult = await _userRepo.get();
    final app = appResult.valueOrNull;
    final user = userResult.valueOrNull;

    final isInit = app?.init ?? false;
    final isRegistered = user?.isRegistered ?? false;
    final isBiometric = user?.isBiometricAuthenticated ?? false;

    String target;
    if (!isInit) {
      target = AppRoutes.onboardingPath;
    } else if (!isRegistered) {
      target = AppRoutes.signupWelcomePath;
    } else if (isBiometric) {
      await _appRepo.setLastDate(_formatDate(_now()));
      target = AppRoutes.signinBiometricPath;
    } else {
      await _appRepo.setLastDate(_formatDate(_now()));
      target = AppRoutes.signinPinPath;
    }

    _timer?.cancel();
    _timer = Timer(_splashDelay, () {
      if (!state$.isClosed) state$.add(SplashNavigate(target));
    });
  }

  String _formatDate(DateTime d) => d.toIso8601String();

  void dispose() {
    _timer?.cancel();
    state$.close();
  }
}
