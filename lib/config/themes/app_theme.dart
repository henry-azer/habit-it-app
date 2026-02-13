import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.roboto,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
      bodySmall: TextStyle(color: AppColors.lightTextSecondary),
      labelLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: AppColors.lightTextSecondary),
      labelSmall: TextStyle(color: AppColors.lightTextDisabled),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
    ),
    iconTheme: IconThemeData(color: AppColors.lightTextSecondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: BorderSide(color: AppColors.lightPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightError, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightCardBorder,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightCardBackground,
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.lightCardBorder),
      labelStyle: TextStyle(color: AppColors.lightTextPrimary),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightOnPrimary,
      elevation: 4,
    ),
  );
}

ThemeData appDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.roboto,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      labelLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: AppColors.darkTextSecondary),
      labelSmall: TextStyle(color: AppColors.darkTextDisabled),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
      backgroundColor: AppColors.darkCardBackground,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),
    iconTheme: IconThemeData(color: AppColors.darkTextSecondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: BorderSide(color: AppColors.darkPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkError, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkCardBorder,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCardBackground,
      selectedColor: AppColors.darkPrimary.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.darkCardBorder),
      labelStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkOnPrimary,
      elevation: 4,
    ),
  );
}
