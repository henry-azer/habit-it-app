import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/media_query_values.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_local_storage_strings.dart';
import '../../../../core/utils/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late IStorageManager _storageManager;
  bool _isUserBiometricAuthenticated = false;
  bool _isUserAuthenticated = false;
  bool _isUserRegistered = false;
  bool _isUserGetStarted = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
    _initUserCachedSession();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startDelay() {
    _timer = Timer(const Duration(milliseconds: 7000), () => _goNext());
  }

  _goNext() {
    if (!_isUserGetStarted) {
      Navigator.pushReplacementNamed(context, Routes.appOnboarding);
      return;
    }

    if (_isUserRegistered) {
      if (!_isUserAuthenticated && _isUserBiometricAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.signinBiometric);
      } else {
        Navigator.pushReplacementNamed(context, Routes.signinPIN);
      }
    } else {
      Navigator.pushReplacementNamed(context, Routes.appSignup);
    }
  }

  Future _initUserCachedSession() async {
    _storageManager = GetIt.instance<IStorageManager>();
    _isUserGetStarted =
        await _storageManager.getValue(AppLocalStorageKeys.isUserGetStarted) ??
            false;
    _isUserAuthenticated = await _storageManager
            .getValue(AppLocalStorageKeys.isUserAuthenticated) ??
        false;
    _isUserRegistered =
        await _storageManager.getValue(AppLocalStorageKeys.isUserRegistered) ??
            false;
    _isUserBiometricAuthenticated = await _storageManager
            .getValue(AppLocalStorageKeys.isUserBiometricAuthenticated) ??
        false;
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
