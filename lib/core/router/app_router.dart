import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Legacy screens — re-exposed as GoRouter routes for FND-005 AC#3 (paths
// remain valid for existing docs / screenshots).
import '../../features/habit/add-habit/presentation/screens/add_habit_screen.dart';
import '../../features/habit/habit/presentation/screens/habit_screen.dart';
import '../../features/habit/manage-habits/presentation/screens/manage_habits_screen.dart';
import '../../features/habit/stats/month-progress/presentation/screens/habit_month_progress.dart';
import '../../features/habit/stats/month-stats/presentation/screens/habit_month_stats.dart';
import '../../features/habit/stats/stats/presentation/screens/habit_stats_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/screens/app_shell.dart';
import '../../features/signin/biometric-signin/presentation/screens/signin_biometric_screen.dart';
import '../../features/signin/pin-signin/presentation/screens/signin_pin_screen.dart';
import '../../features/signup/base-signup/presentation/screens/signup_screen.dart';
import '../../features/signup/local-biometric/presentation/screens/signup_biometric_screen.dart';
import '../../features/signup/local-pin/presentation/screens/signup_pin_screen.dart';
import '../../features/signup/success-signup/presentation/screens/signup_success_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

import 'app_routes.dart';

/// Application-wide GoRouter.
///
/// Implements the routing table in TECHNICAL_STORIES.md §4 with legacy aliases
/// for back-compat. Subsequent epics (AUTH, SET, AI) will replace many of the
/// screen builders, but the route paths themselves remain stable.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splashPath,
  errorBuilder: (context, state) => const _NotFoundScreen(),
  routes: [
    GoRoute(
      path: AppRoutes.splashPath,
      name: AppRoutes.splashName,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingPath,
      name: AppRoutes.onboardingName,
      builder: (_, __) => const OnboardingScreen(),
    ),

    // ---- Legacy signup flow (preserved by AUTH-008) ----
    GoRoute(
      path: AppRoutes.signupWelcomePath,
      name: AppRoutes.signupWelcomeName,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.signupPasscodePath,
      name: AppRoutes.signupPasscodeName,
      builder: (_, __) => const SignupPINScreen(),
    ),
    GoRoute(
      path: AppRoutes.signupBiometricPath,
      name: AppRoutes.signupBiometricName,
      builder: (_, __) => const SignupBiometricScreen(),
    ),
    GoRoute(
      path: AppRoutes.signupSuccessPath,
      name: AppRoutes.signupSuccessName,
      builder: (_, __) => const SignupSuccessScreen(),
    ),

    // ---- Signin (legacy until AUTH-005 ships a lock screen) ----
    GoRoute(
      path: AppRoutes.signinPinPath,
      name: AppRoutes.signinPinName,
      builder: (_, __) => const SigninPINScreen(),
    ),
    GoRoute(
      path: AppRoutes.signinBiometricPath,
      name: AppRoutes.signinBiometricName,
      builder: (_, __) => const SigninBiometricScreen(),
    ),

    // ---- App shell with three branches ----
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.habitsPath,
            name: AppRoutes.habitsName,
            builder: (_, __) => const HabitScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.statsPath,
            name: AppRoutes.statsName,
            builder: (_, __) => const HabitStatsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.settingsPath,
            name: AppRoutes.settingsName,
            builder: (_, __) => const ProfileScreen(),
          ),
        ]),
      ],
    ),

    // ---- Habit detail / management — outside the shell (fullscreen) ----
    GoRoute(
      path: AppRoutes.addHabitPath,
      name: AppRoutes.addHabitName,
      builder: (_, __) => const AddHabitScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageHabitsPath,
      name: AppRoutes.manageHabitsName,
      builder: (context, state) {
        final dayParam = state.uri.queryParameters['day'];
        final fromExtra = state.extra is int ? state.extra as int : null;
        final day = fromExtra ?? int.tryParse(dayParam ?? '') ?? DateTime.now().day;
        return ManageHabitsScreen(selectedDay: day);
      },
    ),

    // ---- Stats sub-screens — fullscreen ----
    GoRoute(
      path: AppRoutes.monthStatsPath,
      name: AppRoutes.monthStatsName,
      builder: (context, state) {
        final date = state.extra is DateTime ? state.extra as DateTime : DateTime.now();
        return HabitMonthStatsScreen(date: date);
      },
    ),
    GoRoute(
      path: AppRoutes.monthProgressPath,
      name: AppRoutes.monthProgressName,
      builder: (context, state) {
        final date = state.extra is DateTime ? state.extra as DateTime : DateTime.now();
        return HabitMonthProgressScreen(date: date);
      },
    ),

    // ---- Legacy `/app/profile` alias (back-compat with screenshots) ----
    GoRoute(
      path: AppRoutes.profilePath,
      redirect: (_, __) => AppRoutes.settingsPath,
    ),
  ],
);

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('No Route Found')),
    );
  }
}
