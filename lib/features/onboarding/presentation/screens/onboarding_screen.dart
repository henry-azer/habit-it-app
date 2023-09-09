import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/features/onboarding/domain/cubit/app_get_started_cubit.dart';
import 'package:habit_it/features/onboarding/presentation/widgets/onboarding_item.dart';

import '../../../../config/routes/app_routes.dart';
import '../widgets/background_final_button.dart';
import '../widgets/onboarding_slider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: AppLocalizationHelper.translate(
          context, AppLocalizationKeys.onboardingGettingStarted),
      onFinish: () {
        BlocProvider.of<AppGetStartedCubit>(context).setAppGetStarted();
        Navigator.pushReplacementNamed(context, Routes.appHome);
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppColors.white,
      ),
      middle: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          AppLocalizationHelper.translate(
              context, AppLocalizationKeys.onboardingTitle),
          style: AppTextStyles.onboardingTitle,
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
