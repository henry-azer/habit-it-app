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
import '../../../../core/validation/validation_types.dart';
import '../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../core/widgets/buttons/button_form_widget.dart';
import '../../../../core/widgets/forms/text_field_widget.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({Key? key}) : super(key: key);

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late IStorageManager _storageManager;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  _saveUsername() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      bool isSaved = false;

      try {
        _storageManager = GetIt.instance<IStorageManager>();
        await _storageManager.setValue(
            AppLocalStorageKeys.currentUsername, username);
        await _storageManager.setValue(
            AppLocalStorageKeys.isUserRegistered, true);
        isSaved = true;
      } catch (exception) {
        AppNotifier.showSnackBar(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupNameFailed),
        );
      }

      if (isSaved) {
        AppNotifier.showSnackBar(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupSuccess),
        );
        Navigator.pushReplacementNamed(context, Routes.appHome);
      }
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
                  context, AppLocalizationKeys.signupSuccessTitle),
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AppImageAssets.signupSuccess,
                    height: 250,
                  ),
                  Text(
                    AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.signupSuccessDescription),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.signupBodyDescription,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFieldWidget(
                      enabled: true,
                      hintText: 'Your Name',
                      controller: _usernameController,
                      hintTextStyle: AppTextStyles.signupNameTextFieldHint,
                      keyboardType: TextInputType.emailAddress,
                      validateType: ValidationTypes.signupName,
                      errorStyle: AppTextStyles.signupNameTextFieldError,
                      errorBorderColor: AppColors.error,
                      borderColor: AppColors.border,
                      borderWidth: 1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.signupNameTextField,
                      cursorColor: AppColors.fontSecondary,
                      secureText: false,
                      onSave: (value) {},
                      contentPadding: const EdgeInsets.only(top: 12,),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ButtonFormWidget(
                      onPress: _saveUsername,
                      child: Text(
                        AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.signupSuccessButton),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.signupSuccessButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
