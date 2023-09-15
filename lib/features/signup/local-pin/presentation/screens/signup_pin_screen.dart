import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_it/features/signup/local-pin/domain/cubit/user_pin_registration_cubit.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/app_assets_manager.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../../core/widgets/otp/otp_text_field_widget.dart';

class SignupPINScreen extends StatefulWidget {
  const SignupPINScreen({Key? key}) : super(key: key);

  @override
  State<SignupPINScreen> createState() => _SignupPINScreenState();
}

class _SignupPINScreenState extends State<SignupPINScreen> {
  @override
  void initState() {
    super.initState();
  }

  _registerUserPIN(String pin) async {
    bool isAuthenticated = false;

    try {
      BlocProvider.of<UserPINRegistrationCubit>(context).registerUserPIN(pin);
      isAuthenticated = true;
    } catch (exception) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signupPINFailed),
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
        resizeToAvoidBottomInset: true,
        appBar: CupertinoAppBar(
          middle: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.signupPINTitle),
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
                    context, AppLocalizationKeys.signupPINDescription),
                textAlign: TextAlign.center,
                style: AppTextStyles.signupBodyDescription,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              OTPTextField(
                fieldHeight: 60,
                numberOfFields: 5,
                cursorColor: AppColors.grey.withOpacity(0.8),
                borderColor: AppColors.white,
                focusedBorderColor: AppColors.grey.withOpacity(0.75),
                showFieldAsBox: true,
                textStyle: AppTextStyles.signupPIN,
                onSubmit: (String pin) async {
                  _registerUserPIN(pin);
                }, // end onSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
}