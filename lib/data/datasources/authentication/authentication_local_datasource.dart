import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';

import '../../../core/utils/app_local_storage_strings.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> registerUserPIN(String pin);
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final IStorageManager storageManager;

  AuthenticationLocalDataSourceImpl({required this.storageManager});

  @override
  Future<void> registerUserPIN(String pin) async {
    await storageManager.setValue(AppLocalStorageKeys.currentUserPIN, pin);
    await storageManager.setValue(AppLocalStorageKeys.isUserAuthenticated, true);
  }
}
