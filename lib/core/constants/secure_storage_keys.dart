/// flutter_secure_storage key names. See TECHNICAL_STORIES.md §6.
abstract final class SecureStorageKeys {
  SecureStorageKeys._();

  /// Format: `"1$<base64Salt>$<base64Hash>"` — version 1, 16-byte salt,
  /// 32-byte PBKDF2-SHA256 hash with 100,000 iterations.
  static const String pinHash = 'auth.pin_hash';
  static const String failedAttempts = 'auth.failed_attempts';
  static const String lockoutUntil = 'auth.lockout_until';

  /// Groq API key — raw string, starts with `gsk_`.
  static const String magicGroqApiKey = 'magic.groq_api_key';
}
