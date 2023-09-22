import 'package:habit_it/core/utils/app_local_storage_strings.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class UserLocalDataSource {
  Future<String> getUsername();

  Future<String> getUserGender();

  Future<bool> getIsUserGetStarted();

  Future<void> setIsUserGetStarted(bool value);

  Future<void> setUsername(String username);

  Future<void> setUserGender(String gender);

  Future<void> clearAllUserData();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final IStorageManager storageManager;

  UserLocalDataSourceImpl({required this.storageManager});

  @override
  Future<String> getUsername() async {
    return await storageManager.getValue(AppLocalStorageKeys.currentUsername) ??
        "";
  }

  @override
  Future<String> getUserGender() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.currentUserGender) ??
        "";
  }

  @override
  Future<bool> getIsUserGetStarted() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.isUserGetStarted) ??
        false;
  }

  @override
  Future<void> setIsUserGetStarted(bool value) async {
    return storageManager.setValue(AppLocalStorageKeys.isUserGetStarted, value);
  }

  @override
  Future<void> setUsername(String username) async {
    return storageManager.setValue(
        AppLocalStorageKeys.currentUsername, username);
  }

  @override
  Future<void> setUserGender(String gender) async {
    return storageManager.setValue(
        AppLocalStorageKeys.currentUserGender, gender);
  }

  @override
  Future<void> clearAllUserData() async {
    return storageManager.clearAll();
  }
}
