import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/data/entities/app.dart';

import '../../../core/utils/app_local_storage_strings.dart';

abstract class AppLocalDataSource {
  Future<App> getApp();

  Future<void> setApp(App app);

  Future<void> setInit(bool value);

  Future<void> setInitDate(String value);

  Future<void> setLastDate(String value);

  Future<void> reset();
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  final IStorageManager storageManager;

  AppLocalDataSourceImpl({required this.storageManager});

  @override
  Future<App> getApp() async {
    final app = await storageManager.getValue<Map<String, dynamic>>(AppLocalStorageKeys.app);
    return app != null ? App.fromJson(app) : App();
  }

  @override
  Future<void> setApp(App app) async {
    return await storageManager.setValue(AppLocalStorageKeys.app, app.toJson());
  }

  @override
  Future<void> setInit(bool value) async {
    final app = await getApp();
    app.init = value;
    return await setApp(app);
  }

  @override
  Future<void> setInitDate(String value) async {
    final app = await getApp();
    app.initDate = value;
    return await setApp(app);
  }

  @override
  Future<void> setLastDate(String value) async {
    final app = await getApp();
    app.lastDate = value;
    return await setApp(app);
  }

  @override
  Future<void> reset() async {
    return storageManager.clearAll();
  }
}
