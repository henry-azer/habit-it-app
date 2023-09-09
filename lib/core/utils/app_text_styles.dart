import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';

import 'app_colors.dart';

class AppTextStyles with Diagnosticable {

  /// SPLASH
  static TextStyle? splashText = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    fontFamily: AppFonts.rubik,
  );

  /// ONBOARDING
  static TextStyle? onboardingTitle = TextStyle(
    fontSize: 20,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? onboardingSubtitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.rubik,
  );

  static TextStyle? onboardingDescription = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );


  static TextStyle? snackbar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );



  static TextStyle? homeText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppFonts.roboto,
  );
}
