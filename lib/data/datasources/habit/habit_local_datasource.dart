import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/numbers_util.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../entities/habit.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getHabits(String month);

  Future<int> getHabitIndexById(String habitId, String month);

  Future<Habit?> getHabitById(String id, String month);

  Future<List<Habit>> getHabitsByDay(DateTime date, String month);

  Future<void> setHabits(List<Habit> habits, String month);

  Future<void> addHabit(Habit habit, String month);

  Future<void> addHabitByName(String habitName, List<String> repeatDays, String month);

  Future<void> updateHabit(Habit habit, String month);

  Future<void> updateHabitsStats(List<Habit> habits, DateTime day, String monthString);

  Future<void> reorderHabit(Habit habit1, Habit habit2, String month);

  Future<void> toggleHabitStatus(Habit habit, int day, String month);

  Future<void> removeHabit(Habit habit, String month);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IStorageManager storageManager;

  HabitLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<Habit>> getHabits(String month) async {
    final habits = await storageManager.getValue<List<dynamic>>(AppLocalStorageKeys.habitMonth + month);
    if (habits == null || habits.isEmpty) return [];
    return habits.map((habitMap) => Habit.fromJson(habitMap)).toList();
  }

  @override
  Future<Habit?> getHabitById(String id, String month) async {
    final habits = await getHabits(month);
    try {
      return habits.firstWhere((habit) => habit.id == id);
    } catch (exception) {
      return null;
    }
  }

  @override
  Future<List<Habit>> getHabitsByDay(DateTime date, String month) async {
    final habits = await storageManager.getValue<List<dynamic>>(AppLocalStorageKeys.habitMonth + month);
    if (habits == null || habits.isEmpty) return [];
    return habits.map((habitMap) => Habit.fromJson(habitMap))
        .where((habit) => habit.repeatDays.contains(DateUtil.getDateDayName(date)))
        .toList();
  }

  @override
  Future<void> setHabits(List<Habit> habits, String month) async {
    return await storageManager.setValue(AppLocalStorageKeys.habitMonth + month,
        habits.map((habitMap) => habitMap.toJson()).toList());
  }

  @override
  Future<void> addHabit(Habit habit, String month) async {
    final habits = await getHabits(month);
    habit.id = NumbersUtil.getRandomId();
    int daysCount = DateUtil.countDaysOfWeekSinceDate(habit.repeatDays, habit.createdDate);
    habit.total = daysCount + (habit.values.length - daysCount);
    habit.totalDone = habit.values.values.where((value) => value == true).length;
    habits.add(habit);
    return await setHabits(habits, month);
  }

  @override
  Future<void> addHabitByName(String habitName, List<String> repeatDays, String month) async {
    final habit = Habit(id: "", total: 0, totalDone: 0, values: {}, name: habitName,
        repeatDays: repeatDays, createdDate: DateUtil.getTodayDate());
    return await addHabit(habit, month);
  }

  @override
  Future<int> getHabitIndexById(String habitId, String month) async {
    final habits = await getHabits(month);
    Habit? savedHabit = await getHabitById(habitId, month);
    return savedHabit != null ? habits.indexWhere((h) => h.id.compareTo(habitId) == 0) : -1;
  }

  @override
  Future<void> updateHabit(Habit habit, String month) async {
    final habits = await getHabits(month);
    final habitIndex = await getHabitIndexById(habit.id, month);
    if (habitIndex > -1) {
      int daysCount = DateUtil.countDaysOfWeekSinceDate(habit.repeatDays, habit.createdDate);
      habit.total = daysCount + (habit.values.length - daysCount);
      habit.totalDone = habit.values.values.where((value) => value == true).length;
      habits[habitIndex] = habit;
      return await setHabits(habits, month);
    }
  }

  @override
  Future<void> updateHabitsStats(List<Habit> habits, DateTime day, String month) async {
    bool isInit = await storageManager.getValue<bool>(AppLocalStorageKeys.habitInit + DateUtil.convertDateToString(day)) ?? false;
    if (isInit) return;

    final List<Habit> monthHabits = await getHabits(month);
    for (var habit in habits) {
      var habitIndex = await getHabitIndexById(habit.id, month);
      var savedHabit = monthHabits.elementAt(habitIndex);
      if (!savedHabit.values.containsKey(day.day) && day.isAfter(savedHabit.createdDate.subtract(const Duration(days: 1)))) {
        savedHabit.values[day.day] = false;
        int daysCount = DateUtil.countDaysOfWeekSinceDate(savedHabit.repeatDays, savedHabit.createdDate);
        savedHabit.total = daysCount + (savedHabit.values.length - daysCount);
        savedHabit.totalDone = savedHabit.values.values.where((value) => value == true).length;
      }
    }

    await setHabits(monthHabits, month);
    await storageManager.setValue(AppLocalStorageKeys.habitInit + DateUtil.convertDateToString(day), true);
  }

  @override
  Future<void> reorderHabit(Habit habit1, Habit habit2, String month) async {
    int oldIndex = await getHabitIndexById(habit1.id, month);
    int newIndex = await getHabitIndexById(habit2.id, month);
    if (oldIndex > -1 && newIndex > -1) {
      var habits = await getHabits(month);
      final item = habits.removeAt(oldIndex);
      habits.insert(newIndex, item);
      return await setHabits(habits, month);
    }
  }

  @override
  Future<void> toggleHabitStatus(Habit habit, int day, String month) async {
    if (habit.values.containsKey(day)) {
      habit.values[day] = !habit.values[day]!;
    } else {
      habit.values[day] = true;
    }
    return await updateHabit(habit, month);
  }

  @override
  Future<void> removeHabit(Habit habit, String month) async {
    final habits = await getHabits(month);
    final habitIndex = await getHabitIndexById(habit.id, month);
    if (habitIndex > -1) {
      habits.removeAt(habitIndex);
      return await setHabits(habits, month);
    }
  }
}
