import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/entities/user.dart';

abstract class UserLocalDataSource {
  Future<User?> getUser();
  Future<void> setUser(User user);
  Future<void> setAuthenticated(bool isAuthenticated);
  Future<bool> isAuthenticated();
  Future<void> setOnboardingCompleted(bool isCompleted);
  Future<bool> isOnboardingCompleted();
  Future<void> clearUserData();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final IStorageManager storageManager;

  UserLocalDataSourceImpl({required this.storageManager});

  @override
  Future<User?> getUser() async {
    final userData = await storageManager.getValue<Map<String, dynamic>>(AppLocalStorageKeys.userData);
    if (userData != null) {
      return User.fromMap(userData);
    }
    return null;
  }

  @override
  Future<void> setUser(User user) async {
    await storageManager.setValue(AppLocalStorageKeys.userData, user.toMap());
  }

  @override
  Future<void> setAuthenticated(bool isAuthenticated) async {
    await storageManager.setValue(AppLocalStorageKeys.isAuthenticated, isAuthenticated);
  }

  @override
  Future<bool> isAuthenticated() async {
    return await storageManager.getValue<bool>(AppLocalStorageKeys.isAuthenticated) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted(bool isCompleted) async {
    await storageManager.setValue(AppLocalStorageKeys.isOnboardingCompleted, isCompleted);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await storageManager.getValue<bool>(AppLocalStorageKeys.isOnboardingCompleted) ?? false;
  }

  @override
  Future<void> clearUserData() async {
    storageManager.removeValue(AppLocalStorageKeys.userData);
    storageManager.removeValue(AppLocalStorageKeys.isAuthenticated);
    storageManager.removeValue(AppLocalStorageKeys.isOnboardingCompleted);
  }
}
