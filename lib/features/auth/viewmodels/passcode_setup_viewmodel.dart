import 'package:rxdart/rxdart.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/auth/app_lock_service.dart';
import '../../../data/repositories/i_user_repository.dart';

/// AUTH-003 — two-phase passcode setup state machine.
enum PasscodeSetupStep { create, confirm }

/// AUTH-003 ViewModel.
///
/// Drives the create → confirm two-phase flow, persisting on match via
/// [AppLockService.enable] + [IUserRepository.setPINAuthentication].
class PasscodeSetupViewModel {
  PasscodeSetupViewModel({
    AppLockService? appLock,
    IUserRepository? userRepo,
  })  : _appLock = appLock ?? getIt<AppLockService>(),
        _userRepo = userRepo ?? getIt<IUserRepository>();

  final AppLockService _appLock;
  final IUserRepository _userRepo;

  final BehaviorSubject<PasscodeSetupStep> step$ =
      BehaviorSubject.seeded(PasscodeSetupStep.create);
  final BehaviorSubject<String> buffer$ = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> error$ = BehaviorSubject.seeded(null);

  /// Set when the second phase succeeds; the screen listens and routes onward.
  final BehaviorSubject<bool> completed$ = BehaviorSubject.seeded(false);

  String _firstPin = '';

  static const int _kPinLength = SecurityConstants.kPinLength;

  void onDigit(String d) {
    final buf = buffer$.value;
    if (buf.length >= _kPinLength) return;
    final next = buf + d;
    buffer$.add(next);
    if (error$.value != null) error$.add(null);
    if (next.length == _kPinLength) advance();
  }

  void onBackspace() {
    final buf = buffer$.value;
    if (buf.isEmpty) return;
    buffer$.add(buf.substring(0, buf.length - 1));
  }

  /// Manual back from the confirm phase — clears state and returns to create.
  void resetToCreate() {
    _firstPin = '';
    buffer$.add('');
    error$.add(null);
    step$.add(PasscodeSetupStep.create);
  }

  /// Internal transition — public for unit testing the state machine.
  Future<void> advance() async {
    final entered = buffer$.value;
    if (entered.length != _kPinLength) return;

    if (step$.value == PasscodeSetupStep.create) {
      _firstPin = entered;
      buffer$.add('');
      step$.add(PasscodeSetupStep.confirm);
      return;
    }

    // Confirm phase.
    if (entered != _firstPin) {
      // Mismatch — reset to create and surface error.
      _firstPin = '';
      buffer$.add('');
      error$.add('mismatch');
      step$.add(PasscodeSetupStep.create);
      return;
    }

    // Match — persist hash + flip the auth flag.
    await _appLock.enable(entered);
    await _userRepo.setPINAuthentication(true);
    completed$.add(true);
  }

  void dispose() {
    step$.close();
    buffer$.close();
    error$.close();
    completed$.close();
  }
}
