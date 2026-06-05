import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../core/managers/biometric/i_biometric_manager.dart';
import '../../../core/services/auth/app_lock_service.dart';
import '../../../core/services/auth/unlock_result.dart';
import '../../../data/repositories/i_user_repository.dart';

/// AUTH-004 — biometric opt-in / unlock screen state.
///
/// Drives `IBiometricManager.authenticate` and persists the opt-in to the
/// user record. The screen translates `result$` events into routing
/// decisions (skip ↔ enable ↔ retry).
class BiometricSigninViewModel {
  BiometricSigninViewModel({
    IBiometricManager? biometric,
    IUserRepository? userRepo,
    AppLockService? appLock,
  })  : _biometric = biometric ?? getIt<IBiometricManager>(),
        _userRepo = userRepo ?? getIt<IUserRepository>(),
        _appLock = appLock ?? getIt<AppLockService>();

  final IBiometricManager _biometric;
  final IUserRepository _userRepo;
  final AppLockService _appLock;

  final BehaviorSubject<bool> attempting$ = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool?> available$ = BehaviorSubject.seeded(null);
  final BehaviorSubject<UnlockResult?> result$ = BehaviorSubject.seeded(null);

  /// Capability probe — call once on screen mount. `available$` emits the
  /// result; screens that find `false` should skip the opt-in.
  Future<void> probe() async {
    final ok = await _biometric.isAvailable();
    available$.add(ok);
  }

  /// Opt-in flow — prompts biometric auth and on success persists the flag.
  /// Returns true on success so the caller can navigate forward; false on
  /// user-cancel / no-enrolled-biometric.
  Future<bool> optIn({required String reason}) async {
    attempting$.add(true);
    try {
      final ok = await _biometric.authenticate(reason: reason);
      if (ok) await _userRepo.setBiometricAuthentication(true);
      return ok;
    } finally {
      attempting$.add(false);
    }
  }

  /// Unlock flow — used by the LockScreen "tap biometric icon" path. Goes
  /// through `AppLockService` so the failed-attempts counter is honoured.
  Future<void> tryUnlock({required String reason}) async {
    attempting$.add(true);
    try {
      result$.add(await _appLock.verifyBiometric(reason: reason));
    } finally {
      attempting$.add(false);
    }
  }

  void dispose() {
    attempting$.close();
    available$.close();
    result$.close();
  }
}
