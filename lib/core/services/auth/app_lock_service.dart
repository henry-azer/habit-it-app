import 'package:flutter/foundation.dart';

import '../../constants/security_constants.dart';
import '../../managers/biometric/i_biometric_manager.dart';
import 'i_passcode_service.dart';
import 'unlock_result.dart';

/// Orchestrates passcode + biometric unlock + lockout policy + the global
/// "is app locked right now" gate used by the GoRouter redirect.
///
/// Port of `vault-it-app/lib/core/services/app_lock_service.dart:30-120` with
/// two additions specific to Habit-It's GoRouter architecture:
///   - `lockedNotifier` (a `ValueNotifier<bool>`) plumbed into
///     `GoRouter.refreshListenable`, so a background-resume after the
///     configured threshold triggers an automatic redirect to `/lock`.
///   - `lastPausedAt` tracked here (not in the screen) so it survives router
///     rebuilds and ViewModel recreation.
///
/// All passcode-related secrets stay inside [_passcode]; this class never
/// touches the raw PIN string except to forward it to verify.
class AppLockService {
  AppLockService({
    required IPasscodeService passcode,
    required IBiometricManager biometric,
    Duration Function()? autoLockThreshold,
  })  : _passcode = passcode,
        _biometric = biometric,
        _autoLockThreshold =
            autoLockThreshold ?? _defaultAutoLockThreshold;

  final IPasscodeService _passcode;
  final IBiometricManager _biometric;
  // Settings (SET-004) plugs the live picker value in via this provider.
  // Until SET-004 lands we default to the 30s constant per PO G-004.
  final Duration Function() _autoLockThreshold;

  static Duration _defaultAutoLockThreshold() =>
      SecurityConstants.kBackgroundLockThreshold;

  // Lockout policy constants (TS-AUTH-005, AC#4).
  static const _firstLockoutAttempt = SecurityConstants.kFirstLockoutAttempt;
  static const _longLockoutAttempt = SecurityConstants.kSecondLockoutAttempt;
  static final _shortLockout = SecurityConstants.kFirstLockoutDuration;
  static final _longLockout = SecurityConstants.kSecondLockoutDuration;
  // How many "wrong" results the UI shows the remaining-attempts count for
  // before the next attempt triggers the short lockout (5 → 30s, so the
  // first wrong attempt shows "4 remaining" before lockout).
  static const _maxAttemptsBeforeShortLockout = _firstLockoutAttempt - 1;

  /// Global lock gate. The GoRouter listens to this via `refreshListenable`
  /// so flipping it to `true` causes an immediate redirect to `/lock` (and
  /// flipping back to `false` lets the router pop back).
  ///
  /// Default `false` because cold-start security gating is handled by
  /// router redirect rules using `isSecurityEnabled()` + the user state.
  final ValueNotifier<bool> lockedNotifier = ValueNotifier<bool>(false);

  /// Tracked when the app moves to background; used on resume to decide
  /// whether the auto-lock threshold has elapsed.
  DateTime? _lastPausedAt;

  Future<bool> isSecurityEnabled() => _passcode.isSet();

  Future<Duration?> getActiveLockout() => _activeLockout();

  /// Phase the app to "locked" without doing any actual auth — used when the
  /// app first launches with security enabled. The redirect rule reads
  /// `lockedNotifier.value` and pushes `/lock`.
  void lockNow() {
    if (!lockedNotifier.value) lockedNotifier.value = true;
  }

  /// Mark the app as unlocked after a successful authentication.
  void unlockNow() {
    if (lockedNotifier.value) lockedNotifier.value = false;
  }

  /// Record the moment the app moved to background. Called from the
  /// lifecycle observer (`AppLockLifecycleObserver`).
  void recordPaused(DateTime now) {
    _lastPausedAt = now;
  }

  /// Called on `AppLifecycleState.resumed`. If security is enabled AND the
  /// app spent at least the configured threshold in the background, flip the
  /// gate so the router redirects to `/lock`.
  Future<void> evaluateResume(DateTime now) async {
    if (!await _passcode.isSet()) {
      _lastPausedAt = null;
      return;
    }
    final pausedAt = _lastPausedAt;
    _lastPausedAt = null;
    if (pausedAt == null) return;
    final elapsed = now.difference(pausedAt);
    if (elapsed >= _autoLockThreshold()) {
      lockNow();
    }
  }

  Future<void> enable(String passcode) async {
    await _passcode.setPasscode(passcode);
  }

  Future<void> disable() async {
    await _passcode.clear();
    unlockNow();
  }

  Future<UnlockResult> verifyPasscode(String input) async {
    // port of vault-it-app/lib/core/services/app_lock_service.dart:58-87
    final activeLockout = await _activeLockout();
    if (activeLockout != null) return UnlockLockedOut(activeLockout);

    if (await _passcode.verify(input)) {
      await _passcode.resetFailedAttempts();
      await _passcode.setLockoutUntil(null);
      unlockNow();
      return const UnlockSuccess();
    }

    await _passcode.incrementFailedAttempts();
    final attempts = await _passcode.getFailedAttempts();

    if (attempts >= _longLockoutAttempt) {
      final until = DateTime.now().add(_longLockout);
      await _passcode.setLockoutUntil(until);
      return UnlockLockedOut(until.difference(DateTime.now()));
    }
    if (attempts >= _firstLockoutAttempt) {
      final until = DateTime.now().add(_shortLockout);
      await _passcode.setLockoutUntil(until);
      return UnlockLockedOut(until.difference(DateTime.now()));
    }

    return UnlockWrong(_maxAttemptsBeforeShortLockout - attempts);
  }

  Future<UnlockResult> verifyBiometric({required String reason}) async {
    if (!await _biometric.isAvailable()) {
      return const UnlockBiometricUnavailable();
    }
    final ok = await _biometric.authenticate(reason: reason, stickyAuth: false);
    if (!ok) return const UnlockBiometricFailed();
    await _passcode.resetFailedAttempts();
    await _passcode.setLockoutUntil(null);
    unlockNow();
    return const UnlockSuccess();
  }

  /// AUTH-007 — change the PIN. Wrong current PIN still counts toward the
  /// AUTH-005 lockout (we don't short-circuit).
  Future<UnlockResult> changePasscode({
    required String current,
    required String next,
  }) async {
    final result = await verifyPasscode(current);
    if (result is! UnlockSuccess) return result;
    await _passcode.setPasscode(next);
    await _passcode.resetFailedAttempts();
    await _passcode.setLockoutUntil(null);
    return const UnlockSuccess();
  }

  /// Inspect the persistent lockout window. Returns null if the window has
  /// passed or was never set; auto-clears stale lockouts.
  Future<Duration?> _activeLockout() async {
    // port of vault-it-app/lib/core/services/app_lock_service.dart:110-119
    final until = await _passcode.getLockoutUntil();
    if (until == null) return null;
    final remaining = until.difference(DateTime.now());
    if (remaining.isNegative || remaining == Duration.zero) {
      await _passcode.setLockoutUntil(null);
      return null;
    }
    return remaining;
  }

  void dispose() {
    lockedNotifier.dispose();
  }
}
