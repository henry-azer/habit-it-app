/// GoRouter path + name constants (FND-005).
abstract final class AppRoutes {
  AppRoutes._();

  static const String splashPath = '/';
  static const String splashName = 'splash';

  static const String onboardingPath = '/onboarding';
  static const String onboardingName = 'onboarding';

  // Signup flow
  static const String signupWelcomePath = '/signup/welcome';
  static const String signupWelcomeName = 'signupWelcome';
  static const String signupPasscodePath = '/signup/passcode';
  static const String signupPasscodeName = 'signupPasscode';
  static const String signupBiometricPath = '/signup/biometric';
  static const String signupBiometricName = 'signupBiometric';
  static const String signupProfilePath = '/signup/profile';
  static const String signupProfileName = 'signupProfile';
  static const String signupSuccessPath = '/signup/success';
  static const String signupSuccessName = 'signupSuccess';
  static const String signupPinMigratePath = '/signup/pin-migrate';
  static const String signupPinMigrateName = 'signupPinMigrate';

  // Signin (legacy, until AUTH-005 lock-screen flow replaces it)
  static const String signinPinPath = '/signin/pin';
  static const String signinPinName = 'signinPin';
  static const String signinBiometricPath = '/signin/biometric';
  static const String signinBiometricName = 'signinBiometric';

  // Lock
  static const String lockPath = '/lock';
  static const String lockName = 'lock';

  // App shell + branches
  static const String appShellPath = '/app';
  static const String habitsPath = '/app/habits';
  static const String habitsName = 'habits';
  static const String statsPath = '/app/stats';
  static const String statsName = 'stats';
  static const String settingsPath = '/app/settings';
  static const String settingsName = 'settings';
  // Legacy alias for the third tab
  static const String profilePath = '/app/profile';
  static const String profileName = 'profile';

  // AUTH-007 — change PIN (reachable from Settings).
  static const String changePinPath = '/settings/security/change-pin';
  static const String changePinName = 'changePin';

  // AUTH-008 (G-003) — legacy 5-digit PIN upgrade.
  static const String passcodeUpgradePath = '/auth/passcode-upgrade';
  static const String passcodeUpgradeName = 'passcodeUpgrade';

  static const String addHabitPath = '/app/habits/add';
  static const String addHabitName = 'addHabit';
  static const String manageHabitsPath = '/app/habits/manage';
  static const String manageHabitsName = 'manageHabits';
  static const String habitDetailPath = '/app/habits/:habitId';
  static const String habitDetailName = 'habitDetail';

  static const String monthStatsPath = '/app/stats/month-stats';
  static const String monthStatsName = 'monthStats';
  static const String monthProgressPath = '/app/stats/month-progress';
  static const String monthProgressName = 'monthProgress';
}
