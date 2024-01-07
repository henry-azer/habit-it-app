import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';

import 'app_colors.dart';

class AppTextStyles with Diagnosticable {
  /// SPLASH
  static TextStyle splashText = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    fontFamily: AppFonts.roboto,
  );

  /// ONBOARDING
  static TextStyle onboardingSubtitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle onboardingDescription = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// SIGNUP
  static TextStyle signupSubtitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupDescription = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupBodyDescription = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupWith = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupPIN = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupNameTextField = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupNameTextFieldHint = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupNameTextFieldError = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupGenderFieldItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupGenderSelectedFieldItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupGenderFieldHint = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupGenderFieldError = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupSuccessButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signupIconTextButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  /// SIGNIN
  static TextStyle signinDescription = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle signinIconTextButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  /// PROFILE
  static TextStyle profileTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle profileUpdateButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle profileCancelButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle profileBackButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle profileIconTextButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  /// HOME
  static TextStyle habitNameText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle noHabitsTextTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle noHabitsTextSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// HEADER
  static TextStyle headerTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle headerTitle2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// STATS
  static TextStyle statsDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// APPBAR
  static TextStyle appbarTitle = TextStyle(
    fontSize: 20,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// FLOATING ACTION BUTTON
  static TextStyle floatingSpeedDialChild = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: AppColors.fontPrimary,
    fontFamily: AppFonts.roboto,
  );

  /// ALERT DIALOG
  static TextStyle alertDialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle alertDialogText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle alertDialogActionTextField = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle alertDialogActionButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );

  static TextStyle alertDialogHintTextField = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    fontFamily: AppFonts.roboto,
  );

  /// SNACKBAR
  static TextStyle snackbar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontSecondary,
    fontFamily: AppFonts.roboto,
  );
}
