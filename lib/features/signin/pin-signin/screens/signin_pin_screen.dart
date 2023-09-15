import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';

import '../../../../config/locale/app_localization_helper.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_local_storage_strings.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../core/widgets/otp/otp_text_field_widget.dart';

class SigninPINScreen extends StatefulWidget {
  const SigninPINScreen({Key? key}) : super(key: key);

  @override
  State<SigninPINScreen> createState() => _SigninPINScreenState();
}

class _SigninPINScreenState extends State<SigninPINScreen> {
  late IStorageManager _storageManager;
  late String _authenticatedPIN;

  @override
  void initState() {
    super.initState();
    _initUserCachedAuthenticationSession();
  }

  Future _initUserCachedAuthenticationSession() async {
    _storageManager = GetIt.instance<IStorageManager>();
    _authenticatedPIN = await _storageManager
        .getValue(AppLocalStorageKeys.currentUserPIN) as String;
  }

  _authenticateUserPIN(String pin) {
    if (pin == _authenticatedPIN) {
      Navigator.pushReplacementNamed(context, Routes.appHome);
    } else {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signinPINInvalid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CupertinoAppBar(
          middle: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.signinPINTitle),
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
                AppImageAssets.pin,
                height: 220,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.signinPINDescription),
                textAlign: TextAlign.center,
                style: AppTextStyles.signinDescription,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              OTPTextField(
                fieldHeight: 60,
                numberOfFields: 5,
                cursorColor: AppColors.grey.withOpacity(0.8),
                borderColor: AppColors.white,
                focusedBorderColor: AppColors.grey.withOpacity(0.75),
                showFieldAsBox: true,
                textStyle: AppTextStyles.signupPIN,
                onSubmit: (String pin) {
                  _authenticateUserPIN(pin);
                }, // end onSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
}
