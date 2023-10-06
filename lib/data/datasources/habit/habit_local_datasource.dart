import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class HabitLocalDataSource {
  Future<List<String>> getHabitMonths();

  Future<bool> getIsCurrentMonthInitialized();

  Future<void> prepareMonthData();

  Future<void> addCurrentMonthToHabitMonths();

  Future<void> setIsCurrentMonthInitialized(bool value);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IStorageManager storageManager;

  HabitLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<String>> getHabitMonths() async {
    List<dynamic> months = await storageManager.getValue(AppLocalStorageKeys.habitMonths) ?? [];
    return months.map((item) => item.toString()).toList();
  }

  @override
  Future<bool> getIsCurrentMonthInitialized() async {
    return await storageManager.getValue(AppLocalStorageKeys.getCurrentMonthIsInitializedKey()) ?? false;
  }

  @override
  Future<void> prepareMonthData() async {
    await addCurrentMonthToHabitMonths();
    await setIsCurrentMonthInitialized(true);
    return;
  }

  @override
  Future<void> setIsCurrentMonthInitialized(bool value) async {
    return await storageManager.setValue(AppLocalStorageKeys.getCurrentMonthIsInitializedKey(), value);
  }

  @override
  Future<void> addCurrentMonthToHabitMonths() async {
    List<String> habitMonths = await getHabitMonths();
    habitMonths.add(DateUtil.getCurrentMonthDateString());
    return await storageManager.setValue(AppLocalStorageKeys.habitMonths, habitMonths);
  }
}
