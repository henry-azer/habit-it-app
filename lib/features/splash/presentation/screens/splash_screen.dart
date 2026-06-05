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
import '../../../../core/di/injection.dart' as new_di;
import '../../../../core/router/app_routes.dart' as new_routes;
import '../../../../core/services/auth/app_lock_service.dart';
import '../../../../core/services/auth/auth_migrator.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../data/datasources/app/app_local_datasource.dart';
import '../../../../data/entities/user.dart';
import 'package:go_router/go_router.dart';

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
      context.go(Routes.appOnboarding);
      return;
    }

    if (!_isUserRegistered) {
      // AUTH-008 — route through the new multi-step signup welcome.
      context.go(new_routes.AppRoutes.signupWelcomePath);
      return;
    }

    // AUTH-001 AC#5 — legacy plain-text PIN holders go through migration.
    if (new_di.getIt.isRegistered<AuthMigrator>()) {
      final pending = await new_di.getIt<AuthMigrator>().isMigrationPending();
      if (pending) {
        if (!mounted) return;
        context.go(new_routes.AppRoutes.signupPinMigratePath);
        return;
      }
    }

    // AUTH-005 — if the new hash is set, force the lock screen via the gate.
    if (new_di.getIt.isRegistered<AppLockService>()) {
      final lock = new_di.getIt<AppLockService>();
      if (await lock.isSecurityEnabled()) {
        await _appLocalDataSource.setLastDate(DateUtil.getTodayDate().toString());
        lock.lockNow();
        if (!mounted) return;
        context.go(new_routes.AppRoutes.lockPath);
        return;
      }
    }

    if (_isUserBiometricAuthenticated) {
      await _appLocalDataSource.setLastDate(DateUtil.getTodayDate().toString());
      context.go(Routes.appSigninBiometric);
    } else {
      await _appLocalDataSource.setLastDate(DateUtil.getTodayDate().toString());
      context.go(Routes.appSigninPIN);
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
