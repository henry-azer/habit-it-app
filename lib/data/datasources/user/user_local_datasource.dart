import 'package:habit_it/core/utils/app_local_storage_strings.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../entities/user.dart';

abstract class UserLocalDataSource {
  Future<User> getUser();

  Future<void> setUser(User user);

  Future<void> setUsernameAndGender(String username, String gender);

  Future<void> setUserAuthentication(bool value);

  Future<void> setUserPINAuthentication(String password);

  Future<void> setUserBiometricAuthentication(bool value);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final IStorageManager storageManager;

  UserLocalDataSourceImpl({required this.storageManager});

  @override
  Future<User> getUser() async {
    final user = await storageManager.getValue<Map<String, dynamic>>(AppLocalStorageKeys.user);
    return user != null ? User.fromJson(user) : User();
  }

  @override
  Future<void> setUser(User user) async {
    return await storageManager.setValue(AppLocalStorageKeys.user, user.toJson());
  }

  @override
  Future<void> setUserAuthentication(bool value) async {
    final user = await getUser();
    user.isAuthenticated = value;
    return await setUser(user);
  }

  @override
  Future<void> setUsernameAndGender(String username, String gender) async {
    final user = await getUser();
    user.gender = gender;
    user.username = username;
    user.isRegistered = true;
    return await setUser(user);
  }

  @override
  Future<void> setUserPINAuthentication(String password) async {
    final user = await getUser();
    user.password = password;
    user.isAuthenticated = true;
    user.isPINAuthenticated = true;
    return await setUser(user);
  }

  @override
  Future<void> setUserBiometricAuthentication(bool value) async {
    final user = await getUser();
    user.isAuthenticated = true;
    user.isBiometricAuthenticated = value;
    return await setUser(user);
  }
}
