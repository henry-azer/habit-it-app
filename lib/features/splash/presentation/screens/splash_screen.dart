import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _navigatorHandler();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _navigatorHandler() {
    _timer = Timer(const Duration(seconds: 2), () {
      _navigateNext();
    });
  }

  _navigateNext() async {
    if (!mounted) return;

    final authProvider = Provider.of<IAuthProvider>(context, listen: false);

    final isOnboarded = await authProvider.isUserOnboarded();
    if (!isOnboarded) {
      Navigator.pushReplacementNamed(context, Routes.onboarding);
      return;
    }

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.app);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
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
              const SizedBox(height: 30),
              Text(
                AppStrings.appName.tr.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
