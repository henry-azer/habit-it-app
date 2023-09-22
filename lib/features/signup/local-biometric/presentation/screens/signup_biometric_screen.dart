import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/routes/app_routes.dart';
import 'package:habit_it/data/datasources/authentication/authentication_local_datasource.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import '../../../../../core/utils/app_assets_manager.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../../core/widgets/buttons/icon_text_button_widget.dart';

class SignupBiometricScreen extends StatefulWidget {
  const SignupBiometricScreen({Key? key}) : super(key: key);

  @override
  State<SignupBiometricScreen> createState() => _SignupBiometricScreenState();
}

class _SignupBiometricScreenState extends State<SignupBiometricScreen> {
  late IBiometricAuthenticationManager _biometricAuthenticationManager;
  late AuthenticationLocalDataSource _authenticationLocalDataSource;

  @override
  void initState() {
    super.initState();
    _initLocalDataSourcesAndManagers();
    _authenticateUserBiometric();
  }

  _initLocalDataSourcesAndManagers() {
    _authenticationLocalDataSource = GetIt.instance<AuthenticationLocalDataSource>();
    _biometricAuthenticationManager = GetIt.instance<IBiometricAuthenticationManager>();
  }


  _authenticateUserBiometric() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _biometricAuthenticationManager.requestBiometricAuthentication();
      await _authenticationLocalDataSource.setIsUserAuthenticated(true);
    } catch (exception) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signupBiometricFailed),
      );
    }

    if (isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.signupSuccess, (route) => false);
    }
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
                  context, AppLocalizationKeys.signupBiometricTitle),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Image.asset(
                AppImageAssets.biometric,
                height: 220,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupBiometricDescription),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupBodyDescription,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              IconTextButton(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.40,
                icon: Icons.fingerprint,
                text: AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupBiometricButton),
                onPressed: _authenticateUserBiometric,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
