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
  static TextStyle? onboardingSubtitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? onboardingDescription = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// SIGNUP
  static TextStyle? signupSubtitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupDescription = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupBodyDescription = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupWith = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupPIN = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupNameTextField = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupNameTextFieldHint = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupNameTextFieldError = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle? signupSuccessButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  /// SIGNIN
  static TextStyle? signinDescription = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// APPBAR
  static TextStyle? appbarTitle = TextStyle(
    fontSize: 20,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// BUTTONS
  static TextStyle? iconTextButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  /// SNACKBAR
  static TextStyle? snackbar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );



  static TextStyle? homeText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: AppFonts.roboto,
  );
}
