import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../services/auth/app_lock_service.dart';

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

// AUTH-005 / AUTH-007 / AUTH-008 — new auth screens.
import '../../features/auth/screens/lock_screen.dart';
import '../../features/auth/screens/change_pin_screen.dart';
import '../../features/auth/screens/passcode_upgrade_screen.dart';
import '../../features/auth/screens/pin_migrate_prompt_screen.dart';
import '../../features/auth/screens/pin_updated_success_screen.dart';
import '../../features/auth/screens/signup_welcome_screen.dart';
import '../../features/auth/screens/signup_passcode_screen.dart';
import '../../features/auth/screens/signup_biometric_opt_in_screen.dart';
import '../../features/auth/screens/signup_profile_screen.dart';

import 'app_routes.dart';

/// Application-wide GoRouter.
///
/// AUTH-005 closes the FND C-3 deferral: `refreshListenable` listens to
/// `AppLockService.lockedNotifier` so a lifecycle resume after the auto-lock
/// threshold forces a redirect to `/lock`, and unlock pops back automatically.
GoRouter buildAppRouter({AppLockService? appLock}) {
  final lock = appLock ?? getIt<AppLockService>();
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: lock.lockedNotifier,
    redirect: (context, state) {
      // Force the user to `/lock` whenever the gate is closed, except when
      // they are already on it (avoids redirect loop).
      if (lock.lockedNotifier.value && state.matchedLocation != AppRoutes.lockPath) {
        return AppRoutes.lockPath;
      }
      // If unlocked and the user is sitting on `/lock`, send them home.
      if (!lock.lockedNotifier.value && state.matchedLocation == AppRoutes.lockPath) {
        return AppRoutes.habitsPath;
      }
      return null;
    },
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

      // ---- AUTH-005 lock screen ----
      GoRoute(
        path: AppRoutes.lockPath,
        name: AppRoutes.lockName,
        builder: (_, __) => const LockScreen(),
      ),

      // ---- AUTH-008 multi-step signup ----
      GoRoute(
        path: AppRoutes.signupWelcomePath,
        name: AppRoutes.signupWelcomeName,
        builder: (_, __) => const SignupWelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupPasscodePath,
        name: AppRoutes.signupPasscodeName,
        builder: (_, __) => const SignupPasscodeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupBiometricPath,
        name: AppRoutes.signupBiometricName,
        builder: (_, __) => const SignupBiometricOptInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupProfilePath,
        name: AppRoutes.signupProfileName,
        builder: (_, __) => const SignupProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupPinMigratePath,
        name: AppRoutes.signupPinMigrateName,
        builder: (_, __) => const PinMigratePromptScreen(),
      ),

      // ---- AUTH G-003 PIN upgrade ----
      GoRoute(
        path: AppRoutes.passcodeUpgradePath,
        name: AppRoutes.passcodeUpgradeName,
        builder: (_, __) => const PasscodeUpgradeScreen(),
      ),

      // ---- AUTH-008 AQ-2 (PM override) — migration-only success screen ----
      GoRoute(
        path: AppRoutes.pinUpdatedPath,
        name: AppRoutes.pinUpdatedName,
        builder: (_, __) => const PinUpdatedSuccessScreen(),
      ),

      // ---- AUTH-007 change PIN (reachable from Settings hub) ----
      GoRoute(
        path: AppRoutes.changePinPath,
        name: AppRoutes.changePinName,
        builder: (_, __) => const ChangePinScreen(),
      ),

      // ---- Legacy signup success (kept for back-compat with old splash) ----
      GoRoute(
        path: AppRoutes.signupSuccessPath,
        name: AppRoutes.signupSuccessName,
        builder: (_, __) => const SignupSuccessScreen(),
      ),
      // Legacy plain signup welcome — left reachable so un-upgraded installs
      // following the old `/signup/welcome` path still work.
      GoRoute(
        path: '/signup/legacy-welcome',
        builder: (_, __) => const SignupScreen(),
      ),

      // ---- Signin (legacy — kept for un-upgraded installs) ----
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
      // Legacy signup PIN / biometric screens — retained for legacy installs
      // that started signup before upgrading.
      GoRoute(
        path: '/signup/legacy-passcode',
        builder: (_, __) => const SignupPINScreen(),
      ),
      GoRoute(
        path: '/signup/legacy-biometric',
        builder: (_, __) => const SignupBiometricScreen(),
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
}

/// Default singleton — built lazily so `getIt<AppLockService>()` is ready.
final GoRouter appRouter = buildAppRouter();

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('No Route Found')),
    );
  }
}
