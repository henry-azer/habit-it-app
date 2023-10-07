import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.background,
    hintColor: AppColors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    unselectedWidgetColor: AppColors.white,
  );
}
