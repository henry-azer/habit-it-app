import 'dart:developer';

import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:local_auth/local_auth.dart';

import 'i_biometric_auth_manager.dart';

class BiometricAuthenticationManager extends IBiometricAuthenticationManager {
  final LocalAuthentication localAuthentication;
  final UserLocalDataSource userLocalDataSource;

  BiometricAuthenticationManager(
      {required this.localAuthentication,
      required this.userLocalDataSource});

  @override
  Future<void> enableBiometricAuthentication() async {
    return await userLocalDataSource.setUserBiometricAuthentication(true);
  }

  @override
  Future<bool> requestBiometricAuthentication() async {
    try {
      return await localAuthentication.authenticate(
          localizedReason: "Authenticate User",
          options: const AuthenticationOptions(
            stickyAuth: true,
          ));
    } catch (exception) {
      log(exception.toString());
      return false;
    }
  }

  @override
  Future<bool> verifyBiometricAuthentication() async {
    try {
      return await localAuthentication.authenticate(
          localizedReason: "Authenticate User",
          options: const AuthenticationOptions(
            stickyAuth: false,
          ));
    } catch (exception) {
      log(exception.toString());
      return false;
    }
  }

  @override
  Future<bool> isBiometricAuthenticationAvailable() async {
    final canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await localAuthentication.isDeviceSupported();
    return canCheckBiometrics && isDeviceSupported;
  }
}
