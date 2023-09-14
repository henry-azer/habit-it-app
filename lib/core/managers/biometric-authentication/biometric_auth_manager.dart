import 'dart:developer';

import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:local_auth/local_auth.dart';

import '../../utils/app_local_storage_strings.dart';
import 'i_biometric_auth_manager.dart';

class BiometricAuthenticationManager extends IBiometricAuthenticationManager {
  final LocalAuthentication localAuthentication;
  final IStorageManager storageManager;

  BiometricAuthenticationManager(
      {required this.localAuthentication, required this.storageManager});

  @override
  Future<void> enableBiometricAuthentication() async {
    await storageManager.setValue(
        AppLocalStorageKeys.isUserBiometricAuthenticated, true);
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
