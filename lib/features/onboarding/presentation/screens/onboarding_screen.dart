import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/features/onboarding/presentation/widgets/onboarding_item_widget.dart';

import '../../../../config/routes/app_routes.dart';
import '../widgets/background_final_button_widget.dart';
import '../widgets/onboarding_slider_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late AppLocalDataSource _appLocalDataSource;

  @override
  void initState() {
    super.initState();
    _initUserLocalDataSource();
  }

  _initUserLocalDataSource() async {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
  }

  _onFinishOnboarding(BuildContext context) async {
    await _appLocalDataSource.setInit(true);
    Navigator.pushReplacementNamed(context, Routes.appSignup);
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: AppLocalizationHelper.translate(
          context, AppLocalizationKeys.onboardingGettingStarted),
      onFinish: () => _onFinishOnboarding(context),
      // Corrected the onFinish function call
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppColors.white,
      ),
      middle: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          AppLocalizationHelper.translate(
              context, AppLocalizationKeys.onboardingTitle),
          style: AppTextStyles.appbarTitle,
        ),
      ),
      totalPage: 3,
      speed: 1.5,
      controllerColor: AppColors.white,
      headerBackgroundColor: AppColors.primary,
      pageBackgroundColor: AppColors.primary,
      background: [Container(), Container(), Container()],
      pageBodies: [
        OnboardingItem(
            title: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageOneTitle),
            image: AppImageAssets.onboarding1,
            description: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageOneDescription)),
        OnboardingItem(
            title: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageTwoTitle),
            image: AppImageAssets.onboarding2,
            description: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageTwoDescription)),
        OnboardingItem(
            title: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageThreeTitle),
            image: AppImageAssets.onboarding3,
            description: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.onboardingPageThreeDescription)),
      ],
    );
  }
}
