
abstract class IBiometricAuthenticationManager {
  Future<bool> requestBiometricAuthentication();
  Future<bool> verifyBiometricAuthentication();
  Future<void> enableBiometricAuthentication();
  Future<bool> isBiometricAuthenticationAvailable();
}