import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/locale/app_localization_helper.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_localization_strings.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:habit_it/data/entities/app.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../data/datasources/app/app_local_datasource.dart';
import '../../../../data/entities/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late UserLocalDataSource _userLocalDataSource;
  late AppLocalDataSource _appLocalDataSource;

  late bool _isUserBiometricAuthenticated = false;
  late bool _isUserRegistered = false;
  late bool _isInit = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
    _initCurrentUserData();
    _navigatorHandler();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _initLocalDataSources() async {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
  }

  _initCurrentUserData() async {
    final App app = await _appLocalDataSource.getApp();
    final User user =  await _userLocalDataSource.getUser();
    setState(() {
      _isInit = app.init;
      _isUserRegistered = user.isRegistered;
      _isUserBiometricAuthenticated = user.isBiometricAuthenticated;
    });
  }

  _navigatorHandler() {
    _timer = Timer(const Duration(seconds: 1), () {
      if (_isUserRegistered) {
        _timer = Timer(const Duration(seconds: 0), () => _navigateNext());
      } else {
        _timer = Timer(const Duration(seconds: 5), () => _navigateNext());
      }
    });
  }

  _navigateNext() async {
    if (!_isInit) {
      Navigator.pushReplacementNamed(context, Routes.appOnboarding);
      return;
    }

    if (!_isUserRegistered) {
      Navigator.pushReplacementNamed(context, Routes.appSignup);
      return;
    }

    if (_isUserBiometricAuthenticated) {
      await _appLocalDataSource.setLastDate(DateUtil.getTodayDate().toString());
      Navigator.pushReplacementNamed(context, Routes.appSigninBiometric);
    } else {
      await _appLocalDataSource.setLastDate(DateUtil.getTodayDate().toString());
      Navigator.pushReplacementNamed(context, Routes.appSigninPIN);
    }
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
