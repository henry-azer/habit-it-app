/// Passcode (PIN) hashing + lockout-state primitive.
///
/// Implemented by [PasscodeServiceImpl] using PBKDF2-SHA256 with 100,000
/// iterations, a 16-byte random salt, and a 32-byte derived key. All
/// operations are async to keep PBKDF2 off the synchronous path.
///
/// PINs are NEVER logged, printed, or persisted in plain text — even in
/// debug. The only on-disk artefact is the encoded
/// `"1$<base64Salt>$<base64Hash>"` string in `flutter_secure_storage`.
abstract class IPasscodeService {
  Future<bool> isSet();
  Future<void> setPasscode(String passcode);
  Future<bool> verify(String passcode);
  Future<void> clear();

  Future<int> getFailedAttempts();
  Future<void> incrementFailedAttempts();
  Future<void> resetFailedAttempts();
  Future<DateTime?> getLockoutUntil();
  Future<void> setLockoutUntil(DateTime? until);
}
