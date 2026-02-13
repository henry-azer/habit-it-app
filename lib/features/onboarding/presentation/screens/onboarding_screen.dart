import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/features/onboarding/presentation/widgets/onboarding_item_widget.dart';

import '../../../../config/routes/app_routes.dart';
import '../widgets/background_final_button_widget.dart';
import '../widgets/onboarding_slider_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

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
    Navigator.pushReplacementNamed(context, Routes.register);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OnBoardingSlider(
      finishButtonText: AppStrings.getStarted.tr,
      onFinish: () => _onFinishOnboarding(context),
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      middle: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          AppStrings.appName.tr.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      totalPage: 3,
      speed: 1.5,
      controllerColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      headerBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      pageBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      background: [Container(), Container(), Container()],
      pageBodies: [
        OnboardingItem(
            title: AppStrings.onboardingTitle1.tr,
            image: AppImageAssets.onboarding1,
            description: AppStrings.onboardingDesc1.tr),
        OnboardingItem(
            title: AppStrings.onboardingTitle2.tr,
            image: AppImageAssets.onboarding2,
            description: AppStrings.onboardingDesc2.tr),
        OnboardingItem(
            title: AppStrings.onboardingTitle3.tr,
            image: AppImageAssets.onboarding3,
            description: AppStrings.onboardingDesc3.tr),
      ],
    );
  }
}
