import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Builds [ThemeData] for light and dark themes with a configurable accent color.
///
/// Consumed by `HabitItApp.build` via `MaterialApp.router.theme` /
/// `darkTheme` and switched by `themeModeNotifier`.
abstract final class ThemeFactory {
  ThemeFactory._();

  static ThemeData light({Color? accent}) =>
      _build(brightness: Brightness.light, accent: accent ?? AppColors.accentDefault);

  static ThemeData dark({Color? accent}) =>
      _build(brightness: Brightness.dark, accent: accent ?? AppColors.accentDefault);

  static ThemeData _build({required Brightness brightness, required Color accent}) {
    final isLight = brightness == Brightness.light;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: isLight ? AppColors.lightPrimary : AppColors.darkPrimary,
      onPrimary: isLight ? AppColors.lightBackground : AppColors.darkBackground,
      primaryContainer: accent,
      onPrimaryContainer: isLight ? AppColors.lightOnSurface : AppColors.darkOnSurface,
      secondary: accent,
      onSecondary: isLight ? AppColors.lightBackground : AppColors.darkBackground,
      surface: isLight ? AppColors.lightSurface : AppColors.darkSurface,
      onSurface: isLight ? AppColors.lightOnSurface : AppColors.darkOnSurface,
      surfaceContainerHighest: isLight ? AppColors.lightSurfaceContainerHigh : AppColors.darkSurfaceContainerHigh,
      surfaceContainerHigh: isLight ? AppColors.lightSurfaceContainerHigh : AppColors.darkSurfaceContainerHigh,
      surfaceContainer: isLight ? AppColors.lightSurfaceContainer : AppColors.darkSurfaceContainer,
      onSurfaceVariant: isLight ? AppColors.lightOnSurfaceVariant : AppColors.darkOnSurfaceVariant,
      outline: isLight ? AppColors.lightOutline : AppColors.darkOutline,
      error: AppColors.error,
      onError: AppColors.darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight ? AppColors.lightBackground : AppColors.darkBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleSmall.copyWith(color: scheme.onSurface),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: accent,
        unselectedItemColor: scheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lgBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: scheme.onPrimary,
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.mdBorder),
          ),
        ),
      ),
      fontFamily: AppTypography.fontFamily,
    );
  }
}
