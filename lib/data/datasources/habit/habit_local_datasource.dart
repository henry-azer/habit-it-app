import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class HabitLocalDataSource {
  Future<List<String>> getAllHabitMonths();

  Future<List<String>> getAllMonthHabits(String month);

  Future<bool> getIsCurrentMonthInitialized();

  Future<void> addCurrentMonthToHabitMonths();

  Future<void> addHabitToCurrentMonth(String habitName);

  Future<void> prepareMonthData();

  Future<void> setIsCurrentMonthInitialized(bool value);

  Future<void> removeHabit(String habitName);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IStorageManager storageManager;

  HabitLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<String>> getAllHabitMonths() async {
    List<dynamic> months =
        await storageManager.getValue(AppLocalStorageKeys.habitMonths) ?? [];
    return months.map((item) => item.toString()).toList();
  }

  @override
  Future<List<String>> getAllMonthHabits(String month) async {
    List<dynamic> months = await storageManager
            .getValue(AppLocalStorageKeys.getMonthHabitsKey(month)) ??
        [];
    return months.map((item) => item.toString()).toList();
  }

  @override
  Future<bool> getIsCurrentMonthInitialized() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.getCurrentMonthIsInitializedKey()) ??
        false;
  }

  @override
  Future<void> prepareMonthData() async {
    await addCurrentMonthToHabitMonths();
    await setIsCurrentMonthInitialized(true);
    return;
  }

  @override
  Future<void> setIsCurrentMonthInitialized(bool value) async {
    return await storageManager.setValue(
        AppLocalStorageKeys.getCurrentMonthIsInitializedKey(), value);
  }

  @override
  Future<void> addCurrentMonthToHabitMonths() async {
    List<String> habitMonths = await getAllHabitMonths();
    habitMonths.add(DateUtil.getCurrentMonthDateString());
    return await storageManager.setValue(
        AppLocalStorageKeys.habitMonths, habitMonths);
  }

  @override
  Future<void> addHabitToCurrentMonth(String habitName) async {
    String month = DateUtil.getCurrentMonthDateString();
    List<String> monthHabits = await getAllMonthHabits(month);
    monthHabits.add(habitName);
    return await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabits);
  }

  @override
  Future<void> removeHabit(String habitName) async {
    String month = DateUtil.getCurrentMonthDateString();
    List<String> monthHabits = await getAllMonthHabits(month);
    monthHabits.remove(habitName);
    return await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabits);
  }
}
