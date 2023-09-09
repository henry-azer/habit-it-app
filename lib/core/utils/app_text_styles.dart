import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';

import 'app_colors.dart';

class AppTextStyles with Diagnosticable {
  static TextStyle? snackbar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? splashText = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? homeText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppFonts.roboto,
  );
}
