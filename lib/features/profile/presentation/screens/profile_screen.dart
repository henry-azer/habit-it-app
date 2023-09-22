import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_notifier.dart';
import 'package:habit_it/data/datasources/authentication/authentication_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../data/entities/user.dart';
import '../widgets/profile_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  late final User _user = User();

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
    final userAuthMethod =
        await _authenticationLocalDataSource.getIsUserBiometricAuthenticated();
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              _buildProfileBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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

  Widget _buildProfileBody() {
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
                  onPress: () {}),
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
}
