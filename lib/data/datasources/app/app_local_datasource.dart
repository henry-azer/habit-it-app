import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/entities/app.dart';

abstract class AppLocalDataSource {
  Future<App?> getAppData();
  Future<void> setAppData(App app);
  Future<void> setThemeMode(String themeMode);
  Future<String> getThemeMode();
  Future<void> clearAppData();

  // Habit-specific methods (preserved)
  Future<void> setInit(bool value);
  Future<void> setInitDate(String value);
  Future<void> setLastDate(String value);
  Future<void> reset();
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  final IStorageManager storageManager;

  AppLocalDataSourceImpl({required this.storageManager});

  @override
  Future<App?> getAppData() async {
    final appData = await storageManager.getValue<Map<String, dynamic>>(AppLocalStorageKeys.appData);
    if (appData != null) {
      return App.fromMap(appData);
    }
    return null;
  }

  @override
  Future<void> setAppData(App app) async {
    await storageManager.setValue(AppLocalStorageKeys.appData, app.toMap());
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    await storageManager.setValue(AppLocalStorageKeys.themeMode, themeMode);
  }

  @override
  Future<String> getThemeMode() async {
    return await storageManager.getValue<String>(AppLocalStorageKeys.themeMode) ?? '';
  }

  @override
  Future<void> clearAppData() async {
    storageManager.removeValue(AppLocalStorageKeys.appData);
    storageManager.removeValue(AppLocalStorageKeys.themeMode);
  }

  // Habit-specific methods (preserved)
  @override
  Future<void> setInit(bool value) async {
    final app = await getAppData();
    if (app != null) {
      final updated = app.copyWith(isInitialized: value);
      await setAppData(updated);
    }
  }

  @override
  Future<void> setInitDate(String value) async {
    final app = await getAppData();
    if (app != null) {
      final updated = app.copyWith(initDate: value);
      await setAppData(updated);
    }
  }

  @override
  Future<void> setLastDate(String value) async {
    final app = await getAppData();
    if (app != null) {
      final updated = app.copyWith(lastDate: value);
      await setAppData(updated);
    }
  }

  @override
  Future<void> reset() async {
    return storageManager.clearAll();
  }
}
