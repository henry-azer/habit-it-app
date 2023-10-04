import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/locale/app_localization_helper.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../core/widgets/buttons/icon_text_button_widget.dart';
import '../../../../data/datasources/authentication/authentication_local_datasource.dart';

class SigninBiometricScreen extends StatefulWidget {
  const SigninBiometricScreen({Key? key}) : super(key: key);

  @override
  State<SigninBiometricScreen> createState() => _SigninBiometricScreenState();
}

class _SigninBiometricScreenState extends State<SigninBiometricScreen> {
  late IBiometricAuthenticationManager _biometricAuthenticationManager;
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late bool _isUserRegistered;

  @override
  void initState() {
    super.initState();
    _initAuthenticationManagers();
    _checkIfUserRegistered();
    _authenticateUserBiometric();
  }

  _initAuthenticationManagers() async {
    _biometricAuthenticationManager = GetIt.instance<IBiometricAuthenticationManager>();
    _authenticationLocalDataSource = GetIt.instance<AuthenticationLocalDataSource>();
  }

  _checkIfUserRegistered() async {
    _isUserRegistered = await _authenticationLocalDataSource.getIsUserRegistered();
    if (!_isUserRegistered) {
      Navigator.pushReplacementNamed(context, Routes.initial);
    }
  }

  _authenticateUserBiometric() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _biometricAuthenticationManager.verifyBiometricAuthentication();
    } catch (exception) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signinBiometricInvalid),
      );
    }

    if (isAuthenticated) {
      await _authenticationLocalDataSource.setIsUserAuthenticated(true);
      Navigator.pushReplacementNamed(context, Routes.app);
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
                  context, AppLocalizationKeys.signinBiometricTitle),
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
                    context, AppLocalizationKeys.signinBiometricDescription),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupBodyDescription,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              IconTextButton(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.40,
                backgroundColor: AppColors.secondary,
                iconColor: AppColors.primary,
                icon: Icons.fingerprint,
                text: AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signupBiometricButton),
                onPressed: _authenticateUserBiometric,
                textStyle: AppTextStyles.signinIconTextButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
