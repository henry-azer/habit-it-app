import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_notifier.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/features/profile/presentation/widgets/base/profile_header_widget.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_assets_manager.dart';
import '../widgets/about-us/about_us_widget.dart';
import '../widgets/profile/profile_menu_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  late AppLocalDataSource _appLocalDataSource;

  bool isAboutUs = false;

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
  }

  _initLocalDataSources() async {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
  }

  _resetAppData() async {
    await _appLocalDataSource.reset();
    Navigator.pushReplacementNamed(context, Routes.initial);
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<IAuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
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
    final authProvider = Provider.of<IAuthProvider>(context);
    final user = authProvider.currentUser;
    final displayName = user?.displayName ?? user?.username ?? AppStrings.user.tr;
    final gender = user?.gender;

    if (isAboutUs) {
      return ProfileHeaderWidget(
        image: AppImageAssets.henry,
        title: AppStrings.aboutUs.tr,
      );
    } else {
      return ProfileHeaderWidget(
        image: gender?.toLowerCase() == 'male'
            ? AppImageAssets.male
            : AppImageAssets.female,
        title: displayName,
      );
    }
  }

  Widget _buildBodySwitcher() {
    if (isAboutUs) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Divider(
                color: isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: AppStrings.resetAppData.tr,
                  icon: Icons.lock_reset_outlined,
                  onPress: () {
                    AppNotifier.showDeleteActionDialog(
                        context: context,
                        message: AppStrings.areYouSure.tr,
                        descriptionMessage: AppStrings.deleteAllDataMessage.tr,
                        onClickYes: _resetAppData);
                  }),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: AppStrings.aboutUs.tr,
                  icon: Icons.info_outline,
                  onPress: () {
                    setState(() {
                      isAboutUs = true;
                    });
                  }),
              const SizedBox(height: 10),
              ProfileMenuItemWidget(
                  title: AppStrings.logout.tr,
                  icon: Icons.logout,
                  textColor: AppColors.error,
                  endIcon: false,
                  onPress: () {
                    AppNotifier.showAlertDialog(
                      context: context,
                      message: AppStrings.logoutConfirmation.tr,
                      onClickYes: _logout,
                    );
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
