class AppLocalStorageKeys {
  /// AUTHENTICATION
  static const String isUserAuthenticated = "AUTHENTICATION/IS_AUTHENTICATED";
  static const String isUserBiometricAuthenticated = "AUTHENTICATION/IS_BIOMETRIC_AUTHENTICATED";

  /// USER DETAILS
  static const String currentUserPIN = "CURRENT_USER/PIN";
  static const String currentUserBiometric = "CURRENT_USER/Biometric";
  static const String isUserGetStarted = "CURRENT_USER/IS_GET_STARTED";

  /// BIOMETRIC
  static const String biometricAuthUserFolder = "BIOMETRIC_USER_SESSION";
  static const String disableBiometricsFolder = "DISABLE_BIOMETRICS";
}
