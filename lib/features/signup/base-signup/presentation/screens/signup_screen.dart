import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import '../../../../../core/utils/app_assets_manager.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../../core/widgets/buttons/icon_text_button_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late IBiometricAuthenticationManager _biometricAuthenticationManager;
  late AppLocalDataSource _appLocalDataSource;
  late bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _initManagers();
    _checkIsAppInit();
    _checkIsBiometricAuthenticationAvailable();
  }

  _initManagers() async {
    _biometricAuthenticationManager = GetIt.instance<IBiometricAuthenticationManager>();
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
  }

  _checkIsAppInit() async {
    final app = await _appLocalDataSource.getApp();
    if (!app.init) {
      Navigator.pushReplacementNamed(context, Routes.appOnboarding);
    }
  }

  _checkIsBiometricAuthenticationAvailable() async {
    bool isBiometricAvailable = await _biometricAuthenticationManager.isBiometricAuthenticationAvailable();
    setState(() {
      _isBiometricAvailable = isBiometricAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CupertinoAppBar(
          middle: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.signupTitle),
              style: AppTextStyles.appbarTitle,
            ),
          ),
          headerBackgroundColor: AppColors.primary,
        ),
        extendBody: true,
        body: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupSubtitle),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupSubtitle,
              ),
              Image.asset(AppImageAssets.signup),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupDescription),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupDescription,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupWith),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupWith,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              if (_isBiometricAvailable) ...{
                Column(
                  children: [
                    IconTextButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.55,
                      backgroundColor: AppColors.secondary,
                      iconColor: AppColors.primary,
                      icon: Icons.fingerprint,
                      text: AppLocalizationHelper.translate(
                          context, AppLocalizationKeys.signupBiometricButton),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.appSignupBiometric);
                      },
                      textStyle: AppTextStyles.signupIconTextButton,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              },
              IconTextButton(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.45,
                backgroundColor: AppColors.secondary,
                iconColor: AppColors.primary,
                icon: Icons.pin,
                text: AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupPINButton),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.appSignupPIN);
                },
                textStyle: AppTextStyles.signupIconTextButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
