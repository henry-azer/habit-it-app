import 'package:flutter/material.dart';
import 'package:habit_it/features/app-navigator/presentation/screens/app_navigator_screen.dart';
import 'package:habit_it/features/habit/manage-habits/presentation/screens/manage_habits_screen.dart';
import 'package:habit_it/features/habit/stats/month-stats/presentation/screens/habit_month_stats.dart';
import 'package:habit_it/features/habit/stats/stats/presentation/screens/habit_stats_screen.dart';
import 'package:habit_it/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:habit_it/features/profile/presentation/screens/profile_screen.dart';
import 'package:habit_it/features/signup/local-biometric/presentation/screens/signup_biometric_screen.dart';
import 'package:habit_it/features/signup/local-pin/presentation/screens/signup_pin_screen.dart';
import 'package:habit_it/features/splash/presentation/screens/splash_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/habit/add-habit/presentation/screens/add_habit_screen.dart';
import '../../features/habit/habit/presentation/screens/habit_screen.dart';
import '../../features/habit/stats/month-progress/presentation/screens/habit_month_progress.dart';
import '../../features/signin/biometric-signin/presentation/screens/signin_biometric_screen.dart';
import '../../features/signin/pin-signin/presentation/screens/signin_pin_screen.dart';
import '../../features/signup/base-signup/presentation/screens/signup_screen.dart';
import '../../features/signup/success-signup/presentation/screens/signup_success_screen.dart';

class Routes {
  static const String initial = '/';
  static const String app = '/app';
  static const String appOnboarding = '/app/onboarding';

  static const String appSignup = '/app/signup';
  static const String appSignupPIN = '/app/signup/pin';
  static const String appSignupBiometric = '/app/signup/biometric';
  static const String appSignupSuccess = '/app/signup/success';

  static const String appSigninPIN = '/app/signin/pin';
  static const String appSigninBiometric = '/app/signin/biometric';

  static const String appHabit = '/app/habit';
  static const String appHabitAdd = '/app/habit/add';
  static const String appHabitManage = '/app/habit/manage';

  static const String appHabitStats = '/app/habit/stats';
  static const String appHabitMonthStats = '/app/habit/stats/month-stats';
  static const String appHabitMonthProgress = '/app/habit/stats/month-progress';

  static const String appProfile = '/app/profile';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initial:
        return MaterialPageRoute(
            builder: (context) {
              return const SplashScreen();
            },
            settings: routeSettings);

      case Routes.appOnboarding:
        return MaterialPageRoute(
            builder: (context) {
              return const OnboardingScreen();
            },
            settings: routeSettings);

      case Routes.appSignup:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupScreen();
            },
            settings: routeSettings);

      case Routes.appSignupBiometric:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupBiometricScreen();
            },
            settings: routeSettings);

      case Routes.appSignupPIN:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupPINScreen();
            },
            settings: routeSettings);

      case Routes.appSignupSuccess:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupSuccessScreen();
            },
            settings: routeSettings);

      case Routes.appSigninPIN:
        return MaterialPageRoute(
            builder: (context) {
              return const SigninPINScreen();
            },
            settings: routeSettings);

      case Routes.appSigninBiometric:
        return MaterialPageRoute(
            builder: (context) {
              return const SigninBiometricScreen();
            },
            settings: routeSettings);

      case Routes.app:
        return MaterialPageRoute(
            builder: (context) {
              return const AppNavigatorScreen();
            },
            settings: routeSettings);

      case Routes.appHabit:
        return MaterialPageRoute(
            builder: (context) {
              return const HabitScreen();
            },
            settings: routeSettings);

      case Routes.appHabitAdd:
        return MaterialPageRoute(
            builder: (context) {
              return const AddHabitScreen();
            },
            settings: routeSettings);

      case Routes.appHabitManage:
        int selectedDay = routeSettings.arguments as int;
        return MaterialPageRoute(
            builder: (context) {
              return ManageHabitsScreen(selectedDay: selectedDay,);
            },
            settings: routeSettings);

      case Routes.appHabitStats:
        return MaterialPageRoute(
            builder: (context) {
              return const HabitStatsScreen();
            },
            settings: routeSettings);

      case Routes.appHabitMonthStats:
        DateTime date = routeSettings.arguments as DateTime;
        return MaterialPageRoute(
            builder: (context) {
              return HabitMonthStatsScreen(date: date,);
            },
            settings: routeSettings);

      case Routes.appHabitMonthProgress:
        DateTime date = routeSettings.arguments as DateTime;
        return MaterialPageRoute(
            builder: (context) {
              return HabitMonthProgressScreen(date: date,);
            },
            settings: routeSettings);

      case Routes.appProfile:
        return MaterialPageRoute(
            builder: (context) {
              return const ProfileScreen();
            },
            settings: routeSettings);



      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: Center(
                child: Text(AppStrings.noRouteFound),
              ),
            )));
  }
}
