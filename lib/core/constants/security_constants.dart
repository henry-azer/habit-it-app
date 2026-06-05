/// Authentication / security constants.
abstract final class SecurityConstants {
  SecurityConstants._();

  static const int kPinLength = 4;
  static const int kPbkdf2Iterations = 100000;
  static const int kSaltBytes = 16;
  static const int kHashBytes = 32;
  static const String kFormatVersion = '1';

  static const int kFirstLockoutAttempt = 5;
  static const Duration kFirstLockoutDuration = Duration(seconds: 30);
  static const int kSecondLockoutAttempt = 10;
  static const Duration kSecondLockoutDuration = Duration(minutes: 5);

  /// AUTH-005 — lock after this much time backgrounded.
  static const Duration kBackgroundLockThreshold = Duration(seconds: 30);
}
