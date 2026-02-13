import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/features/app-navigator/presentation/screens/app_navigator_screen.dart';
import 'package:habit_it/features/auth/presentation/screens/signin_screen.dart';
import 'package:habit_it/features/auth/presentation/screens/signup_screen.dart';
import 'package:habit_it/features/habit/manage-habits/presentation/screens/manage_habits_screen.dart';
import 'package:habit_it/features/habit/stats/month-stats/presentation/screens/habit_month_stats.dart';
import 'package:habit_it/features/habit/stats/stats/presentation/screens/habit_stats_screen.dart';
import 'package:habit_it/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:habit_it/features/profile/presentation/screens/profile_screen.dart';
import 'package:habit_it/features/splash/presentation/screens/splash_screen.dart';
import 'package:habit_it/features/habit/add-habit/presentation/screens/add_habit_screen.dart';
import 'package:habit_it/features/habit/habit/presentation/screens/habit_screen.dart';
import 'package:habit_it/features/habit/stats/month-progress/presentation/screens/habit_month_progress.dart';

class Routes {
  static const String initial = '/';
  static const String app = '/app';
  static const String onboarding = '/onboarding';

  static const String login = '/auth/login';
  static const String register = '/auth/register';

  static const String appHabit = '/app/habit';
  static const String appHabitAdd = '/app/habit/add';
  static const String appHabitManage = '/app/habit/manage';

  static const String appHabitStats = '/app/habit/stats';
  static const String appHabitMonthStats = '/app/habit/stats/month-stats';
  static const String appHabitMonthProgress = '/app/habit/stats/month-progress';

  static const String appProfile = '/app/profile';
  static const String settings = '/app/settings';
  static const String userProfile = '/app/settings/profile';
  static const String changePassword = '/app/settings/change-password';
  static const String theme = '/app/settings/theme';
  static const String language = '/app/settings/language';
  static const String about = '/app/settings/about';
  static const String privacyPolicy = '/app/terms/privacy-policy';
  static const String termsOfService = '/app/terms/terms-of-service';
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

      case Routes.onboarding:
        return MaterialPageRoute(
            builder: (context) {
              return const OnboardingScreen();
            },
            settings: routeSettings);

      case Routes.login:
        return MaterialPageRoute(
            builder: (context) {
              return const SignInScreen();
            },
            settings: routeSettings);

      case Routes.register:
        return MaterialPageRoute(
            builder: (context) {
              return const SignUpScreen();
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
