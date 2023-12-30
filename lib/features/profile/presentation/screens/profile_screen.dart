import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_notifier.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
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
import '../widgets/month-picker/month_picker.dart';
import '../widgets/profile/profile_menu_item_widget.dart';
import '../widgets/profile/update_profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DateTime _habitInitializedDate = DateTime.now();
  late AppLocalDataSource _appLocalDataSource;
  late HabitLocalDataSource _habitLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  late User _updatedUser = User();
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
    _habitLocalDataSource = GetIt.instance<HabitLocalDataSource>();
  }

  _initLocalData() async {
    final user = await _userLocalDataSource.getUser();
    final habitInitMonth = await _habitLocalDataSource.getHabitInitializedMonth();
    setState(() {
      _user = user;
      _habitInitializedDate = habitInitMonth;
    });
  }

  _resetAppData() async {
    await _appLocalDataSource.reset();
    Navigator.pushReplacementNamed(context, Routes.initial);
  }

  _submitUpdateUserFrom() async {
    _formKey.currentState!.save();

    if (_updatedUser.username.isEmpty) {
      AppNotifier.showActionDialog(
          context: context,
          message: AppLocalizationHelper.translate(context, AppLocalizationKeys.signupNameError),
          onClickYes: () => Navigator.pop(context));
      return;
    }
    if (_updatedUser.gender.isEmpty) {
      AppNotifier.showActionDialog(
          context: context,
          message: AppLocalizationHelper.translate(context, AppLocalizationKeys.signupGenderError),
          onClickYes: () => Navigator.pop(context));
      return;
    }

    bool isSaved = false;
    try {
      await _userLocalDataSource.setUsernameAndGender(_updatedUser.username, _updatedUser.gender);
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

  _navigateToMonthProgress() async {
    DateTime? selectedDate = await showMonthPicker(
      context: context,
      initialDate: _habitInitializedDate,
      firstDate: _habitInitializedDate,
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      Navigator.pushNamed(context, Routes.monthProgress, arguments: selectedDate);
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
        title: AppLocalizationHelper.translate(context, AppLocalizationKeys.profileUpdateTitle),
      );
    } else if (isAboutUs) {
      return ProfileHeaderWidget(
        image: AppImageAssets.henry,
        title: AppLocalizationHelper.translate(context, AppLocalizationKeys.appCreator),
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
                  title: "Month Progress Report",
                  icon: LineAwesomeIcons.calendar,
                  onPress: _navigateToMonthProgress),
              ProfileMenuItemWidget(
                  title: "Update User Profile",
                  icon: LineAwesomeIcons.user_edit,
                  onPress: () {
                    setState(() {
                      isUpdatingProfile = true;
                    });
                  }),
              ProfileMenuItemWidget(
                  title: "Reset App Data",
                  icon: Icons.lock_reset_outlined,
                  onPress: () {
                    AppNotifier.showActionDialog(
                        context: context,
                        message: "Are you sure?",
                        onClickYes: _resetAppData);
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
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: "About Us",
                  icon: LineAwesomeIcons.info,
                  onPress: () {
                    setState(() {
                      isAboutUs = true;
                    });
                  }),
              ProfileMenuItemWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: AppColors.red,
                  endIcon: false,
                  onPress: () async {
                    if (_user.isBiometricAuthenticated) {
                      Navigator.pushReplacementNamed(context, Routes.signinBiometric);
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
}
