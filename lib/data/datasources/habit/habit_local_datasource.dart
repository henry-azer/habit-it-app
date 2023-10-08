import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/numbers_util.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class HabitLocalDataSource {
  Future<List<String>> getAllHabitMonths();

  Future<List<String>> getAllMonthHabitsForMonth(String month);

  Future<Map<String, bool>> getAllMonthHabitsForDay(String month, String day);

  Future<bool> getIsCurrentMonthInitialized();

  Future<DateTime> getHabitInitializedMonth();

  Future<bool> getIsHabitDone(String name, String month, String day);

  Future<void> addCurrentMonthToHabitMonths();

  Future<void> addHabitToCurrentMonth(String name, String month);

  Future<void> prepareMonthData();

  Future<void> setIsCurrentMonthInitialized(bool value);

  Future<void> setHabitInitializedMonth(String month);

  Future<void> moveHabitToNextIndex(String habit, String month);

  Future<void> moveHabitToPreviousIndex(String habit, String month);

  Future<void> updateHabitName(String oldName, String newName, String month);

  Future<void> setHabitStatus(
      String name, String month, String day, bool status);

  Future<void> toggleHabitStatus(String name, String month, String day);

  Future<void> removeHabit(String name, String month);
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
  Future<List<String>> getAllMonthHabitsForMonth(String month) async {
    List<dynamic> habitsList = await storageManager
            .getValue(AppLocalStorageKeys.getMonthHabitsKey(month)) ??
        [];
    return habitsList.map((item) => item.toString()).toList();
  }

  @override
  Future<Map<String, bool>> getAllMonthHabitsForDay(
      String month, String day) async {
    Map<String, bool> habits = {};
    List<String> habitsList = await getAllMonthHabitsForMonth(month);
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
  Future<DateTime> getHabitInitializedMonth() async {
    String initMonth = await storageManager
            .getValue(AppLocalStorageKeys.getHabitInitializedMonthKey()) ??
        "";
    return DateUtil.convertMonthStringToDate(initMonth);
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
    await setHabitInitializedMonth(DateUtil.getCurrentMonthDateString());
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
  Future<void> setHabitInitializedMonth(String month) async {
    return await storageManager.setValue(
        AppLocalStorageKeys.getHabitInitializedMonthKey(), month);
  }

  @override
  Future<void> addHabitToCurrentMonth(String name, String month) async {
    List<String> monthHabitsList = await getAllMonthHabitsForMonth(month);
    monthHabitsList.add(name + NumbersUtil.getRandomCode());
    return await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabitsList);
  }

  @override
  Future<void> updateHabitName(
      String oldName, String newName, String month) async {
    List<String> monthHabitsList = await getAllMonthHabitsForMonth(month);
    int oldIndex = monthHabitsList.indexOf(oldName);
    newName += NumbersUtil.getRandomCode();
    monthHabitsList.insert(oldIndex, newName);
    await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabitsList);
    await _moveHabitDataToAnotherHabit(oldName, newName, month);
    return await removeHabit(oldName, month);
  }

  @override
  Future<void> toggleHabitStatus(String name, String month, String day) async {
    bool isDone = await getIsHabitDone(name, month, day);
    return await storageManager.setValue(
            AppLocalStorageKeys.getHabitKey(name, month, day), !isDone) ??
        false;
  }

  @override
  Future<void> setHabitStatus(
      String name, String month, String day, bool status) async {
    return await storageManager.setValue(
            AppLocalStorageKeys.getHabitKey(name, month, day), status) ??
        false;
  }

  @override
  Future<void> moveHabitToNextIndex(String habit, String month) async {
    List<String> monthHabits = await getAllMonthHabitsForMonth(month);
    int index = monthHabits.indexOf(habit);
    if (index != -1 && index < monthHabits.length - 1) {
      monthHabits.remove(habit);
      monthHabits.insert(index + 1, habit);
    }
    await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabits);
  }

  @override
  Future<void> moveHabitToPreviousIndex(String habit, String month) async {
    List<String> monthHabits = await getAllMonthHabitsForMonth(month);
    int index = monthHabits.indexOf(habit);
    if (index != -1 && index > 0) {
      monthHabits.remove(habit);
      monthHabits.insert(index - 1, habit);
    }
    await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabits);
  }

  @override
  Future<void> removeHabit(String name, String month) async {
    String month = DateUtil.getCurrentMonthDateString();
    List<String> monthHabitsList = await getAllMonthHabitsForMonth(month);
    monthHabitsList.remove(name);
    await storageManager.setValue(
        AppLocalStorageKeys.getMonthHabitsKey(month), monthHabitsList);
    await _removeHabitRelatedData(name, month);
    return;
  }

  Future<void> _removeHabitRelatedData(String name, String month) async {
    DateTime firstDate = DateUtil.getFirstDayOfCurrentMonth();
    DateTime lastDate = DateUtil.getTodayDate();
    while (
        firstDate.isBefore(lastDate) || firstDate.isAtSameMomentAs(lastDate)) {
      String day = DateUtil.convertDateToString(firstDate);
      storageManager
          .removeValue(AppLocalStorageKeys.getHabitKey(name, month, day));
      firstDate =
          DateTime(firstDate.year, firstDate.month, firstDate.day + 1, 0);
    }
    return;
  }

  Future<void> _moveHabitDataToAnotherHabit(
      String oldHabit, String newHabit, String month) async {
    DateTime firstDate = DateUtil.getFirstDayOfCurrentMonth();
    DateTime lastDate = DateUtil.getTodayDate();
    while (
        firstDate.isBefore(lastDate) || firstDate.isAtSameMomentAs(lastDate)) {
      String day = DateUtil.convertDateToString(firstDate);
      bool isDone = await getIsHabitDone(oldHabit, month, day);
      await setHabitStatus(newHabit, month, day, isDone);
      firstDate =
          DateTime(firstDate.year, firstDate.month, firstDate.day + 1, 0);
    }
    return;
  }
}
