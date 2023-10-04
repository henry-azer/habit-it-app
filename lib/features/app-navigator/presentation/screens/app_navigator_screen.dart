import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../data/datasources/authentication/authentication_local_datasource.dart';
import '../widgets/navigation_bar_widget.dart';

class AppNavigatorScreen extends StatefulWidget {
  const AppNavigatorScreen({Key? key}) : super(key: key);

  @override
  State<AppNavigatorScreen> createState() => _AppNavigatorScreenState();
}

class _AppNavigatorScreenState extends State<AppNavigatorScreen> with WidgetsBindingObserver {
  late AuthenticationLocalDataSource _authenticationLocalDataSource;
  late bool _isUserBiometricAuthenticated;
  late bool _isUserAuthenticated;

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
      _setUserAuthenticatedFalse();
    }
  }

  _initLocalDataSources() {
    _authenticationLocalDataSource = GetIt.instance<AuthenticationLocalDataSource>();
  }

  _checkIfUserAuthenticated() async {
    _isUserAuthenticated = await _authenticationLocalDataSource.getIsUserAuthenticated();
    if (!_isUserAuthenticated) {
      _isUserBiometricAuthenticated = await _authenticationLocalDataSource.getIsUserBiometricAuthenticated();
      if (_isUserBiometricAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.signinBiometric);
      } else {
        Navigator.pushReplacementNamed(context, Routes.signinPIN);
      }
    }
  }

  _setUserAuthenticatedFalse() async {
    await _authenticationLocalDataSource.setIsUserAuthenticated(false);
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
