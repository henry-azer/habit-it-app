import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class HabitLocalDataSource {
  Future<List<String>> getAllHabitMonths();

  Future<Map<String, bool>> getAllMonthHabits(String month, String day);

  Future<bool> getIsCurrentMonthInitialized();

  Future<bool> getIsHabitDone(String name, String month, String day);

  Future<void> addCurrentMonthToHabitMonths();

  Future<void> addHabitToCurrentMonth(String name, String day);

  Future<void> prepareMonthData();

  Future<void> setIsCurrentMonthInitialized(bool value);

  Future<void> removeHabit(String name, String month, String day);
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
  Future<Map<String, bool>> getAllMonthHabits(String month, String day) async {
    Map<String, bool> habits = {};
    List<String> habitsList = await _getAllMonthHabitsList(month);
    for (var habit in habitsList) {
      habits[habit] = await getIsHabitDone(habit, month, day);
    }
    return habits;
  }

  @override
  Future<bool> getIsCurrentMonthInitialized() async {
    return await storageManager
            .getValue(AppLocalStorageKeys.getCurrentMonthIsInitializedKey()) ??
        false;
  }

  @override
  Future<bool> getIsHabitDone(String habit, String month, String day) async {
    return await storageManager
            .getValue(AppLocalStorageKeys.getHabitKey(habit, month, day)) ??
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
  Future<void> addHabitToCurrentMonth(String name, String day) async {
    String month = DateUtil.getCurrentMonthDateString();
    List<String> monthHabitsList = await _getAllMonthHabitsList(month);
    monthHabitsList.add(name);
    return await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabitsList);
  }

  @override
  Future<void> removeHabit(String name, String month, String day) async {
    String month = DateUtil.getCurrentMonthDateString();
    List<String> monthHabitsList = await _getAllMonthHabitsList(month);
    monthHabitsList.remove(name);
    return await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabitsList);
  }

  Future<List<String>> _getAllMonthHabitsList(String month) async {
    List<dynamic> habitsList = await storageManager
        .getValue(AppLocalStorageKeys.getMonthHabitsKey(month)) ??
        [];
    return habitsList.map((item) => item.toString()).toList();
  }
}
