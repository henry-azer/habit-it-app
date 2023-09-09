import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isUserGetStarted = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _isUserGetStartedCache();
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startDelay() {
    _timer = Timer(const Duration(milliseconds: 7000), () => _goNext());
  }

  _goNext() => {
        if (_isUserGetStarted)
          {Navigator.pushReplacementNamed(context, Routes.appHome)}
        else
          {Navigator.pushReplacementNamed(context, Routes.appOnboarding)}
      };

  Future _isUserGetStartedCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isUserGetStarted =
        sharedPreferences.getBool(AppStrings.cachedIsUserGetStarted) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImageAssets.logo,
                height: 300,
              ),
              SizedBox(
                height: context.height * 0.05,
              ),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.splashTitle),
                style: AppTextStyles.splashText,
              ),
              SizedBox(
                height: context.height * 0.10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
