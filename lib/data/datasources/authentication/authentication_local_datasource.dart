import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';

import '../../../core/utils/app_local_storage_strings.dart';

abstract class AuthenticationLocalDataSource {
  Future<bool> getIsUserAuthenticated();

  Future<bool> getIsUserBiometricAuthenticated();

  Future<bool> getIsUserRegistered();

  Future<String> getUserPIN();

  Future<void> setUserPIN(String pin);

  Future<void> setIsUserRegistered(bool value);

  Future<void> setIsUserAuthenticated(bool value);

  Future<void> setIsUserBiometricAuthenticated(bool value);
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final IStorageManager storageManager;

  AuthenticationLocalDataSourceImpl({required this.storageManager});

  @override
  Future<bool> getIsUserBiometricAuthenticated() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.isUserBiometricAuthenticated) ??
        false;
  }

  @override
  Future<bool> getIsUserAuthenticated() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.isUserAuthenticated) ??
        false;
  }

  @override
  Future<bool> getIsUserRegistered() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.isUserRegistered) ??
        false;
  }

  @override
  Future<String> getUserPIN() async {
    return await storageManager.getValue(AppLocalStorageKeys.currentUserPIN) ??
        "";
  }

  @override
  Future<void> setUserPIN(String pin) async {
    return await storageManager.setValue(
        AppLocalStorageKeys.currentUserPIN, pin);
  }

  @override
  Future<void> setIsUserRegistered(bool value) async {
    return storageManager.setValue(AppLocalStorageKeys.isUserRegistered, value);
  }

  @override
  Future<void> setIsUserBiometricAuthenticated(bool value) {
    return storageManager.setValue(
        AppLocalStorageKeys.isUserBiometricAuthenticated, value);
  }

  @override
  Future<void> setIsUserAuthenticated(bool value) async {
    return await storageManager.setValue(
        AppLocalStorageKeys.isUserAuthenticated, value);
  }
}
