import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_notifier.dart';
import 'package:habit_it/data/datasources/authentication/authentication_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../config/locale/app_localization_helper.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/validation/validation_types.dart';
import '../../../../core/widgets/buttons/button_widget.dart';
import '../../../../core/widgets/forms/dropdown_field_widget.dart';
import '../../../../core/widgets/forms/text_field_widget.dart';
import '../../../../data/entities/user.dart';
import '../widgets/profile_menu_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  late final User _user = User();
  bool isUpdatingProfile = false;

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
    _initCurrentUserData();
  }

  _initLocalDataSources() async {
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
    _authenticationLocalDataSource =
        GetIt.instance<AuthenticationLocalDataSource>();
  }

  _initCurrentUserData() async {
    final username = await _userLocalDataSource.getUsername();
    final userGender = await _userLocalDataSource.getUserGender();
    final userAuthMethod = await _authenticationLocalDataSource.getIsUserBiometricAuthenticated();
    setState(() {
      _user.username = username;
      _user.gender = userGender;
      _user.isUserBiometricAuthenticated = userAuthMethod;
    });
  }

  _clearAllUserDataAction() {
    _userLocalDataSource.clearAllUserData();
    Navigator.pushReplacementNamed(context, Routes.initial);
  }

  _submitFrom() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      if (_user.username.isEmpty) {
        AppNotifier.showSnackBar(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupNameError),
        );
        return;
      }

      if (_user.gender.isEmpty) {
        AppNotifier.showSnackBar(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupGenderError),
        );
        return;
      }
      _saveUserData();
    }
  }

  _saveUserData() async {
    bool isSaved = false;
    try {
      await _userLocalDataSource.setUsername(_user.username);
      await _userLocalDataSource.setUserGender(_user.gender);
      isSaved = true;
    } catch (exception) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.profileUpdateFailed),
      );
      return;
    }

    if (isSaved) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.profileUpdateSuccess),
      );
      setState(() {
        isUpdatingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildBodySwitcher(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 75,
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                        image: AssetImage(_user.gender == "Male"
                            ? AppImageAssets.male
                            : AppImageAssets.female))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Text(
                  _user.username,
                  style: AppTextStyles.profileUsername,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBodySwitcher() {
    if (isUpdatingProfile) {
      return _buildUpdateProfile();
    } else {
      return _buildBody();
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Divider(
                color: AppColors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: "Month Progress",
                  icon: LineAwesomeIcons.calendar,
                  onPress: () {}),
              ProfileMenuItemWidget(
                  title: "Update Profile",
                  icon: LineAwesomeIcons.user_edit,
                  onPress: () {
                    setState(() {
                      isUpdatingProfile = true;
                    });
                  }),
              ProfileMenuItemWidget(
                  title: "About Us",
                  icon: LineAwesomeIcons.info,
                  onPress: () {}),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Divider(
                color: AppColors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: "Clear All User Data",
                  icon: Icons.delete_outline,
                  onPress: () {
                    AppNotifier.showActionDialog(
                        context: context,
                        message: "Are you sure?",
                        onClickYes: _clearAllUserDataAction);
                  }),
              ProfileMenuItemWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: AppColors.red,
                  endIcon: false,
                  onPress: () async {
                    if (_user.isUserBiometricAuthenticated) {
                      Navigator.pushReplacementNamed(
                          context, Routes.signinBiometric);
                    } else {
                      Navigator.pushReplacementNamed(context, Routes.signinPIN);
                    }
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Text(
            AppLocalizationHelper.translate(
                context, AppLocalizationKeys.profileUpdateTitle),
            style: AppTextStyles.profileUpdateTitle,
          ),
          const SizedBox(height: 15),
          Divider(
            color: AppColors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 30),
          Form(
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
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: DropdownFieldWidget<String>(
                    borderWidth: 1,
                    hintText: 'Gender',
                    items: AppConstants.genders,
                    borderColor: AppColors.border,
                    hintTextStyle: AppTextStyles.signupGenderFieldHint,
                    errorStyle: AppTextStyles.signupGenderFieldError,
                    errorBorderColor: AppColors.error,
                    itemTextStyle: AppTextStyles.signupGenderFieldItem,
                    selectedItemTextStyle:
                        AppTextStyles.signupGenderSelectedFieldItem,
                    validateType: ValidationTypes.signupGender,
                    onSave: (value) {
                      if (value != null) {
                        setState(() {
                          _user.gender = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                onPress: () {
                  setState(() {
                    isUpdatingProfile = false;
                  });
                },
                backgroundColor: Colors.transparent,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderColor: AppColors.border,
                borderWidth: 0.7,
                child: Text(
                  AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.cancel),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.profileCancelButtonText,
                ),
              ),
              ButtonWidget(
                onPress: _submitFrom,
                backgroundColor: AppColors.secondary,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderWidth: 0.7,
                borderColor: AppColors.border,
                child: Text(
                  AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.update),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.profileUpdateButtonText,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
