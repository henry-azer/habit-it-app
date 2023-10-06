import 'date_util.dart';

class AppLocalStorageKeys {
  /// AUTHENTICATION
  static const String isUserRegistered = "AUTHENTICATION/IS_REGISTERED";
  static const String isUserAuthenticated = "AUTHENTICATION/IS_AUTHENTICATED";
  static const String isUserBiometricAuthenticated = "AUTHENTICATION/IS_BIOMETRIC_AUTHENTICATED";

  /// USER DETAILS
  static const String isUserGetStarted = "CURRENT_USER/IS_GET_STARTED";
  static const String currentUserBiometric = "CURRENT_USER/BIOMETRIC";
  static const String currentUserPIN = "CURRENT_USER/PIN";
  static const String currentUsername = "CURRENT_USER/USERNAME";
  static const String currentUserGender = "CURRENT_USER/GENDER";

  /// HABIT
  static const String habit = "HABIT/";
  static const String habitMonths = "HABIT/MONTHS";
  static const String isMonthInitialized = "/IS_INITIALIZED";

  static getCurrentMonthIsInitializedKey() {
    return habit + DateUtil.getCurrentMonthDateString() + isMonthInitialized;
  }
}
