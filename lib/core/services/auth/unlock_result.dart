/// Discriminated outcome of a passcode or biometric unlock attempt.
///
/// Port of `vault-it-app/lib/core/services/app_lock_service.dart:4-28`.
sealed class UnlockResult {
  const UnlockResult();
}

class UnlockSuccess extends UnlockResult {
  const UnlockSuccess();
}

class UnlockWrong extends UnlockResult {
  /// Attempts remaining before the *next* short lockout window kicks in.
  /// 0 means the current attempt was the trigger.
  final int attemptsRemainingBeforeLockout;
  const UnlockWrong(this.attemptsRemainingBeforeLockout);
}

class UnlockLockedOut extends UnlockResult {
  /// Remaining duration until the lockout expires. Always positive.
  final Duration remaining;
  const UnlockLockedOut(this.remaining);
}

class UnlockBiometricUnavailable extends UnlockResult {
  const UnlockBiometricUnavailable();
}

class UnlockBiometricFailed extends UnlockResult {
  const UnlockBiometricFailed();
}
