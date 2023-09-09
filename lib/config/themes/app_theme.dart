import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';

ThemeData appTheme() {
  return ThemeData(
      backgroundColor: AppColors.background,
      primaryColor: AppColors.background,
      hintColor: AppColors.white,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      unselectedWidgetColor: AppColors.white,
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20)),
      textTheme: TextTheme(
        titleMedium: TextStyle(
          height: 1.3,
          fontSize: 45,
          color: AppColors.fontPrimary,
          fontFamily: AppStrings.fontFamilyComfortaa,
        ),
      ));
}
