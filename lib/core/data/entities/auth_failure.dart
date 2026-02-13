abstract class AuthFailure {
  final String message;
  final String? code;

  const AuthFailure(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure([super.message = 'Network connection failed'])
      : super(code: 'network_error');
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure(
      [super.message = 'Invalid credentials'])
      : super(code: 'invalid_credentials');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure([super.message = 'Email is already exists'])
      : super(code: 'email_already_in_use');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([super.message = 'Password is too weak'])
      : super(code: 'weak_password');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure([super.message = 'Invalid email format'])
      : super(code: 'invalid_email');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([super.message = 'User not found'])
      : super(code: 'user_not_found');
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure([super.message = 'Session expired'])
      : super(code: 'token_expired');
}

class BiometricNotAvailableFailure extends AuthFailure {
  const BiometricNotAvailableFailure(
      [super.message = 'Biometric authentication not available'])
      : super(code: 'biometric_not_available');
}

class BiometricFailedFailure extends AuthFailure {
  const BiometricFailedFailure(
      [super.message = 'Biometric authentication failed'])
      : super(code: 'biometric_failed');
}

class UnknownFailure extends AuthFailure {
  const UnknownFailure([super.message = 'An unknown error occurred'])
      : super(code: 'unknown_error');
}

class ServerFailure extends AuthFailure {
  const ServerFailure([super.message = 'Server error occurred'])
      : super(code: 'server_error');
}

class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure([super.message = 'Email not verified'])
      : super(code: 'email_not_verified');
}

class OfflineFailure extends AuthFailure {
  const OfflineFailure([super.message = 'No internet connection'])
      : super(code: 'offline');
}
