/// New (AUTH-004) biometric manager contract.
///
/// Distinct from the legacy `IBiometricAuthenticationManager` which was tied to
/// `UserLocalDataSource` and pre-Hive auth flags. This interface is purely
/// about the device's biometric capability + a single authenticate call; the
/// caller owns persistence of the opt-in flag.
abstract class IBiometricManager {
  /// True when the device can perform biometric auth (sensor present + at
  /// least one enrolled credential).
  Future<bool> isAvailable();

  /// Prompt the OS biometric sheet with [reason]. Returns true on success,
  /// false on user cancel, no enrolled biometrics, or any platform error.
  ///
  /// [stickyAuth] mirrors `local_auth`'s flag — true for enable / unlock
  /// flows, false for fire-and-forget background checks.
  Future<bool> authenticate({required String reason, bool stickyAuth = true});
}
