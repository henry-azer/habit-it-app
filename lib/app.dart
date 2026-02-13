import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/config/localization/language_provider.dart';
import 'package:habit_it/config/routes/app_routes.dart';
import 'package:habit_it/config/themes/app_theme.dart';
import 'package:habit_it/config/themes/theme_provider.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:habit_it/core/providers/supabase_auth_provider.dart';
import 'package:habit_it/core/providers/biometric_provider.dart';
import 'package:habit_it/injection_container.dart';
import 'package:provider/provider.dart';

class HabitItApp extends StatelessWidget {
  const HabitItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<IAuthProvider>(create: (_) => SupabaseAuthProvider()),
        ChangeNotifierProvider<BiometricProvider>(create: (_) => sl<BiometricProvider>()),
      ],
      builder: (context, child) {
        return Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            return Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return MaterialApp(
                  title: AppStrings.appName.tr,
                  locale: languageProvider.currentLocale,
                  debugShowCheckedModeBanner: false,
                  theme: appTheme(),
                  darkTheme: appDarkTheme(),
                  themeMode: themeProvider.themeMode,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  supportedLocales: languageProvider.availableLanguagesLocales,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode == locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },

                  builder: (context, child) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;

                    final overlayStyle = SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness:
                          isDark ? Brightness.light : Brightness.dark,
                      statusBarBrightness:
                          isDark ? Brightness.light : Brightness.dark,
                      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
                      systemNavigationBarIconBrightness:
                          isDark ? Brightness.light : Brightness.dark,
                      systemNavigationBarDividerColor: Theme.of(context).scaffoldBackgroundColor
                    );

                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: overlayStyle,
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
