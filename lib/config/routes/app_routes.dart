import 'package:flutter/material.dart';
import 'package:habit_it/features/calendar-tasker/screens/calendar_tasker_screen.dart';
import 'package:habit_it/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:habit_it/features/signin/biometric-signin/screens/signin_biometric_screen.dart';
import 'package:habit_it/features/signin/pin-signin/screens/signin_pin_screen.dart';
import 'package:habit_it/features/signup/base-signup/screens/signup_screen.dart';
import 'package:habit_it/features/signup/local-biometric/presentation/screens/signup_biometric_screen.dart';
import 'package:habit_it/features/signup/local-pin/presentation/screens/signup_pin_screen.dart';
import 'package:habit_it/features/signup/success-signup/screens/signup_success_screen.dart';
import 'package:habit_it/features/splash/presentation/screens/splash_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/home/presentation/screens/home_screen.dart';

class Routes {
  static const String initial = '/';
  static const String appOnboarding = '/app-onboarding';

  static const String appSignup = '/app-signup';
  static const String signupPIN = '/app-signup/pin';
  static const String signupBiometric = '/app-signup/biometric';
  static const String signupSuccess = '/app-signup/success';

  static const String signinPIN = '/app-signin/pin';
  static const String signinBiometric = '/app-signin/biometric';

  static const String appHome = '/app-home';
  static const String appCalendarTasker = '/app-calendar-tasker';
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

      case Routes.signupBiometric:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupBiometricScreen();
            },
            settings: routeSettings);

      case Routes.signupPIN:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupPINScreen();
            },
            settings: routeSettings);

      case Routes.signupSuccess:
        return MaterialPageRoute(
            builder: (context) {
              return const SignupSuccessScreen();
            },
            settings: routeSettings);

      case Routes.signinPIN:
        return MaterialPageRoute(
            builder: (context) {
              return const SigninPINScreen();
            },
            settings: routeSettings);

      case Routes.signinBiometric:
        return MaterialPageRoute(
            builder: (context) {
              return const SigninBiometricScreen();
            },
            settings: routeSettings);

      case Routes.appHome:
        return MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
            settings: routeSettings);

      case Routes.appCalendarTasker:
        return MaterialPageRoute(
            builder: (context) {
              return const CalendarTaskerScreen();
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
