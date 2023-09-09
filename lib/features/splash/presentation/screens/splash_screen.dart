import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startDelay() {_timer = Timer(const Duration(milliseconds: 8000), () => _goNext());}

  _goNext() => {Navigator.pushReplacementNamed(context, Routes.appHome)};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Text("Splash Screen", style: AppTextStyle.homeText,),
        ),
      ),
    );
  }
}
