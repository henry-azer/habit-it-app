import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/widgets/buttons/button_widget.dart';
import 'package:habit_it/data/datasources/authentication/authentication_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:habit_it/data/entities/user.dart';

import '../../../../config/locale/app_localization_helper.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/validation/validation_types.dart';
import '../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';
import '../../../../core/widgets/dropdown/custom_dropdown.dart';
import '../../../../core/widgets/forms/text_field_widget.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({Key? key}) : super(key: key);

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _genderTextController = TextEditingController();
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  late final User _user = User();

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
  }

  _initLocalDataSources() async {
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
    _authenticationLocalDataSource =
        GetIt.instance<AuthenticationLocalDataSource>();
  }

  _submitFrom() async {
    _formKey.currentState!.save();

    if (_user.username.isEmpty) {
      AppNotifier.showErrorDialog(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupNameError));
      return;
    }
    if (_user.gender.isEmpty) {
      AppNotifier.showErrorDialog(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupGenderError));
      return;
    }

    _saveUserData();
  }

  _saveUserData() async {
    bool isSaved = false;
    try {
      await _userLocalDataSource.setUsername(_user.username);
      await _userLocalDataSource.setUserGender(_user.gender);
      await _authenticationLocalDataSource.setIsUserRegistered(true);
      isSaved = true;
    } catch (exception) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signupFailed),
      );
      return;
    }

    if (isSaved) {
      Navigator.pushReplacementNamed(context, Routes.app);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: _buildAppBar(),
        extendBody: true,
        body: _buildBody(),
      ),
    );
  }

  CupertinoAppBar _buildAppBar() {
    return CupertinoAppBar(
      middle: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupSuccessTitle),
          style: AppTextStyles.appbarTitle,
        ),
      ),
      headerBackgroundColor: AppColors.primary,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            _buildHeader(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _buildForm(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            _buildSubmitButton(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFieldWidget(
              enabled: true,
              hintText: 'Username',
              hintTextStyle: AppTextStyles.signupNameTextFieldHint,
              keyboardType: TextInputType.emailAddress,
              validateType: ValidationTypes.signupName,
              errorStyle: AppTextStyles.signupNameTextFieldError,
              errorBorderColor: AppColors.error,
              borderColor: AppColors.border,
              borderWidth: 1,
              maxLines: 1,
              maxLength: 16,
              textAlign: TextAlign.center,
              style: AppTextStyles.signupNameTextField,
              cursorColor: AppColors.fontSecondary,
              secureText: false,
              onSave: (value) {
                setState(() {
                  _user.username = value;
                });
              },
              contentPadding: const EdgeInsets.only(
                top: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: CustomDropdown(
              fillColor: Colors.transparent,
              selectedStyle: AppTextStyles.signupGenderSelectedFieldItem,
              hintStyle: AppTextStyles.signupGenderFieldHint,
              hintText: 'Gender',
              items: AppConstants.genders,
              borderRadius: BorderRadius.zero,
              errorStyle: AppTextStyles.signupGenderFieldError,
              onChanged: (value) {
                _genderTextController.text = value;
                setState(() {
                  _user.gender = value;
                });
              },
              controller: _genderTextController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ButtonWidget(
      width: 320,
      height: 50,
      borderRadius: 0,
      borderWidth: 1.0,
      borderColor: AppColors.border,
      backgroundColor: AppColors.secondary,
      onPress: _submitFrom,
      child: Text(
        AppLocalizationHelper.translate(
            context, AppLocalizationKeys.signupSuccessButton),
        textAlign: TextAlign.center,
        style: AppTextStyles.signupSuccessButton,
      ),
    );
  }
}
