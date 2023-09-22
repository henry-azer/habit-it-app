import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../data/datasources/authentication/authentication_local_datasource.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  bool _isUserBiometricAuthenticated = false;
  bool _isUserRegistered = false;
  bool _isUserGetStarted = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
    _initLocalDataSources();
    _initCurrentUserData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startDelay() {
    _timer = Timer(const Duration(seconds: 4), () => _goNext());
  }

  _goNext() {
    if (!_isUserGetStarted) {
      Navigator.pushReplacementNamed(context, Routes.appOnboarding);
      return;
    }

    if (!_isUserRegistered) {
      Navigator.pushReplacementNamed(context, Routes.appSignup);
      return;
    }

    if (_isUserBiometricAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.signinBiometric);
    } else {
      Navigator.pushReplacementNamed(context, Routes.signinPIN);
    }
  }

  _initLocalDataSources() async {
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
    _authenticationLocalDataSource = GetIt.instance<AuthenticationLocalDataSource>();
  }

  _initCurrentUserData() async {
    _isUserGetStarted = await _userLocalDataSource.getIsUserGetStarted();
    _isUserRegistered = await _authenticationLocalDataSource.getIsUserRegistered();
    _isUserBiometricAuthenticated = await _authenticationLocalDataSource.getIsUserBiometricAuthenticated();
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
