import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../data/entities/user.dart';
import '../widgets/navigation_bar_widget.dart';

class AppNavigatorScreen extends StatefulWidget {
  const AppNavigatorScreen({Key? key}) : super(key: key);

  @override
  State<AppNavigatorScreen> createState() => _AppNavigatorScreenState();
}

class _AppNavigatorScreenState extends State<AppNavigatorScreen> with WidgetsBindingObserver {
  late UserLocalDataSource _userLocalDataSource;

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
    _checkIfUserAuthenticated();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      updateUser();
    }
  }

  _initLocalDataSources() {
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
  }

  _checkIfUserAuthenticated() async {
    final User user = await _userLocalDataSource.getUser();
    if (!user.isAuthenticated) {
      if (user.isBiometricAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.appSigninBiometric);
      } else {
        Navigator.pushReplacementNamed(context, Routes.appSigninPIN);
      }
    }
  }

  Future<void> updateUser() async {
    final User user = await _userLocalDataSource.getUser();
    user.isAuthenticated = false;
    await _userLocalDataSource.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Scaffold(
        bottomNavigationBar: NavigationBarWidget(),
      ),
    );
  }
}
