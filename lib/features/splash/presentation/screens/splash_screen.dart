import 'dart:async';

import 'package:flutter/material.dart';
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
    _timer = Timer(const Duration(milliseconds: 1000), () => _goNext());
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
          child: Text(
            "Splash Screen",
            style: AppTextStyles.homeText,
          ),
        ),
      ),
    );
  }
}
