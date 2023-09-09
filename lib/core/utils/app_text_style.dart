import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'app_colors.dart';
import 'app_strings.dart';

class AppTextStyle with Diagnosticable {
  static TextStyle? snackbar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppStrings.fontFamilyComfortaa,
  );

  static TextStyle? splashText = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppStrings.fontFamilyComfortaa,
  );

  static TextStyle? homeText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppStrings.fontFamilyComfortaa,
  );
}
