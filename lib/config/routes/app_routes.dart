import 'package:flutter/material.dart';
import 'package:habit_it/features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class Routes {
  static const String initial = '/';
  static const String appHome = '/app-home';
  static const String appOnboarding = '/app-onboarding';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (context,) {
          return const SplashScreen();
        }, settings: routeSettings);

      case Routes.appHome:
        return MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }, settings: routeSettings);

      case Routes.appOnboarding:
        return MaterialPageRoute(builder: (context) {
          return const OnboardingScreen();
        }, settings: routeSettings);

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) =>
        const Scaffold(
          body: Center(
            child: Text(AppStrings.noRouteFound),
          ),
        )));
  }
}
