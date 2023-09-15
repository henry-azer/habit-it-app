import 'package:habit_it/core/utils/app_local_storage_strings.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class UserLocalDataSource {
  Future<void> cacheIsApGetStarted();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final IStorageManager storageManager;

  UserLocalDataSourceImpl({required this.storageManager});

  @override
  Future<void> cacheIsApGetStarted() async {
    storageManager.setValue(AppLocalStorageKeys.isUserGetStarted, true);
  }
}
