import 'package:rxdart/rxdart.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/auth/app_lock_service.dart';
import '../../../core/services/auth/unlock_result.dart';

/// AUTH-005 — lock-screen PIN entry ViewModel.
///
/// Owns the in-memory PIN buffer + result stream. The screen subscribes to
/// `result$` to react to unlock outcomes (success → router pops back, wrong →
/// shake + status text, locked-out → countdown).
class PasscodeSigninViewModel {
  PasscodeSigninViewModel({AppLockService? appLock})
      : _appLock = appLock ?? getIt<AppLockService>();

  final AppLockService _appLock;

  final BehaviorSubject<String> buffer$ = BehaviorSubject.seeded('');
  final BehaviorSubject<UnlockResult?> result$ = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> processing$ = BehaviorSubject.seeded(false);

  static const int _kPinLength = SecurityConstants.kPinLength;

  /// Append a digit. Triggers `submit()` when buffer reaches the PIN length.
  Future<void> onDigit(String d) async {
    if (processing$.value) return;
    final buf = buffer$.value;
    if (buf.length >= _kPinLength) return;
    final next = buf + d;
    buffer$.add(next);
    if (next.length == _kPinLength) await submit();
  }

  void onBackspace() {
    if (processing$.value) return;
    final buf = buffer$.value;
    if (buf.isEmpty) return;
    buffer$.add(buf.substring(0, buf.length - 1));
  }

  /// Public for tests. Submits the buffer to `AppLockService.verifyPasscode`.
  Future<void> submit() async {
    final entered = buffer$.value;
    if (entered.length != _kPinLength) return;
    processing$.add(true);
    try {
      final result = await _appLock.verifyPasscode(entered);
      result$.add(result);
      if (result is! UnlockSuccess) {
        // Clear buffer on any non-success outcome so the next attempt starts
        // from zero.
        buffer$.add('');
      }
    } finally {
      processing$.add(false);
    }
  }

  /// Manual biometric trigger from the keypad icon.
  Future<void> tryBiometric(String reason) async {
    if (processing$.value) return;
    processing$.add(true);
    try {
      final result = await _appLock.verifyBiometric(reason: reason);
      result$.add(result);
    } finally {
      processing$.add(false);
    }
  }

  void dispose() {
    buffer$.close();
    result$.close();
    processing$.close();
  }
}
