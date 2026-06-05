import 'package:flutter/material.dart';

import 'config/locale/app_localizations_setup.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/auth/app_lock_lifecycle_observer.dart';
import 'core/services/auth/app_lock_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/utils/app_strings.dart';

/// Root app widget.
///
/// Watches the three reactive notifiers (themeMode, accentColor, language) and
/// rebuilds [MaterialApp.router] with the matching `ThemeFactory` output. This
/// is the entry point for FND-005 (GoRouter) and FND-004 (theme tokens).
class HabitItApp extends StatelessWidget {
  const HabitItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Color>(
          valueListenable: accentColorNotifier,
          builder: (context, accent, _) {
            return ValueListenableBuilder<Locale>(
              valueListenable: languageNotifier,
              builder: (context, locale, _) {
                return MaterialApp.router(
                  title: AppStrings.appName,
                  locale: locale,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeFactory.light(accent: accent),
                  darkTheme: ThemeFactory.dark(accent: accent),
                  themeMode: themeMode,
                  routerConfig: appRouter,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  // AUTH-005 — wrap the app in a lifecycle observer so the
                  // AppLockService can track pause/resume and trigger the
                  // 30s background-lock per G-004.
                  builder: (context, child) => AppLockLifecycleObserver(
                    service: getIt<AppLockService>(),
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
