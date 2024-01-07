import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_notifier.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:habit_it/data/enums/gender.dart';
import 'package:habit_it/features/profile/presentation/widgets/base/profile_header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../config/locale/app_localization_helper.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../data/entities/user.dart';
import '../widgets/about-us/about_us_widget.dart';
import '../widgets/profile/profile_menu_item_widget.dart';
import '../widgets/profile/update_profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AppLocalDataSource _appLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;

  late final User _updatedUser = User();
  late User _user = User();

  bool isUpdatingProfile = false;
  bool isAboutUs = false;

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
    _initLocalData();
  }

  _initLocalDataSources() async {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
  }

  _initLocalData() async {
    final user = await _userLocalDataSource.getUser();
    setState(() {
      _user = user;
    });
  }

  _resetAppData() async {
    await _appLocalDataSource.reset();
    Navigator.pushReplacementNamed(context, Routes.initial);
  }

  _submitUpdateUserFrom() async {
    _formKey.currentState!.save();

    if (_updatedUser.username.isEmpty) {
      AppNotifier.showErrorDialog(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupNameError));
      return;
    }
    if (_updatedUser.gender.isEmpty) {
      AppNotifier.showErrorDialog(
          context: context,
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.signupGenderError));
      return;
    }

    bool isSaved = false;
    try {
      await _userLocalDataSource.setUsernameAndGender(
          _updatedUser.username, _updatedUser.gender);
      isSaved = true;
    } catch (exception) {
      return;
    }

    if (isSaved) {
      setState(() {
        _user.username = _updatedUser.username;
        _user.gender = _updatedUser.gender;
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
              _buildHeaderSwitcher(),
              _buildBodySwitcher(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSwitcher() {
    if (isUpdatingProfile) {
      return ProfileHeaderWidget(
        image: _user.gender == Gender.male.value
            ? AppImageAssets.male
            : AppImageAssets.female,
        title: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.profileUpdateTitle),
      );
    } else if (isAboutUs) {
      return ProfileHeaderWidget(
        image: AppImageAssets.henry,
        title: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.appCreator),
      );
    } else {
      return ProfileHeaderWidget(
        image: _user.gender == Gender.male.value
            ? AppImageAssets.male
            : AppImageAssets.female,
        title: _user.username,
      );
    }
  }

  Widget _buildBodySwitcher() {
    if (isUpdatingProfile) {
      return UpdateProfileWidget(
        updatedUser: _updatedUser,
        formKey: _formKey,
        onCancel: () {
          setState(() {
            isUpdatingProfile = false;
          });
        },
        onSubmit: _submitUpdateUserFrom,
      );
    } else if (isAboutUs) {
      return AboutUsWidget(
        onBackPressed: () {
          setState(() {
            isAboutUs = false;
          });
        },
      );
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
                  title: AppLocalizationHelper.translate(context,
                      AppLocalizationKeys.profileUpdateUserProfileTitle),
                  icon: LineAwesomeIcons.user_edit,
                  onPress: () {
                    setState(() {
                      isUpdatingProfile = true;
                    });
                  }),
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
              ProfileMenuItemWidget(
                  title: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.profileResetAppData),
                  icon: Icons.lock_reset_outlined,
                  onPress: () {
                    AppNotifier.showDeleteActionDialog(
                        context: context,
                        message: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.areYouSure),
                        descriptionMessage: AppLocalizationHelper.translate(
                            context,
                            AppLocalizationKeys
                                .profileYouAreAboutToRemoveAllData),
                        onClickYes: _resetAppData);
                  }),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.profileAboutUs),
                  icon: LineAwesomeIcons.info,
                  onPress: () {
                    setState(() {
                      isAboutUs = true;
                    });
                  }),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.logout),
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: AppColors.red,
                  endIcon: false,
                  onPress: () async {
                    if (_user.isBiometricAuthenticated) {
                      Navigator.pushReplacementNamed(
                          context, Routes.appSigninBiometric);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, Routes.appSigninPIN);
                    }
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
