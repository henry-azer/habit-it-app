import 'package:flutter/material.dart';
import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';

class HabitItApp extends StatelessWidget {
  const HabitItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      localeResolutionCallback:
          AppLocalizationsSetup.localeResolutionCallback,
      localizationsDelegates:
          AppLocalizationsSetup.localizationsDelegates,
    );
  }
}
