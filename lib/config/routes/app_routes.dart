// Legacy `Routes` + `AppRoutes.onGenerateRoute` shim.
//
// All new code should reference `core/router/app_routes.dart` and use
// `context.go(...)` / `context.goNamed(...)` directly. Legacy screens that
// call `Navigator.pushReplacementNamed(context, Routes.xxx)` still work
// because `MaterialApp.router` resolves named routes through the registered
// `appRouter`.
//
// The `Routes.xxx` constants below are *path strings*, identical to the
// path constants in `core/router/app_routes.dart`. They are kept for
// source-level back-compat. New code MUST use `AppRoutes` (from
// `core/router/app_routes.dart`).

class Routes {
  static const String initial = '/';
  static const String app = '/app/habits';
  static const String appOnboarding = '/onboarding';

  static const String appSignup = '/signup/welcome';
  static const String appSignupPIN = '/signup/passcode';
  static const String appSignupBiometric = '/signup/biometric';
  static const String appSignupSuccess = '/signup/success';

  static const String appSigninPIN = '/signin/pin';
  static const String appSigninBiometric = '/signin/biometric';

  static const String appHabit = '/app/habits';
  static const String appHabitAdd = '/app/habits/add';
  static const String appHabitManage = '/app/habits/manage';

  static const String appHabitStats = '/app/stats';
  static const String appHabitMonthStats = '/app/stats/month-stats';
  static const String appHabitMonthProgress = '/app/stats/month-progress';

  static const String appProfile = '/app/settings';
}
