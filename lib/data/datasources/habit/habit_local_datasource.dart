import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/numbers_util.dart';
import 'package:habit_it/data/enums/habit_state.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../entities/habit.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getHabits(String month);

  Future<int> getHabitIndexById(String habitId, String month);

  Future<Habit?> getHabitById(String id, String month);

  Future<List<Habit>> getHabitsByDay(DateTime date, String month);

  Future<void> setHabits(List<Habit> habits, String month);

  Future<void> addHabit(String name, List<String> repeatDays, String month);

  Future<void> updateHabit(Habit habit, String month);

  Future<void> updateDayHabits(DateTime day, String monthString);

  Future<bool> isMonthHabitsInit(String month);

  Future<void> moveMonthHabits(String lastMonth, String currentMonth, bool value);

  Future<void> reorderHabit(Habit habit1, Habit habit2, String month);

  Future<void> toggleHabitStatus(Habit habit, int day, String month);

  Future<void> suspendHabit(Habit habit, int day, String month);

  Future<void> unsuspendHabit(Habit habit, int day, String month);

  Future<void> removeHabit(Habit habit, String month);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IStorageManager storageManager;

  HabitLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<Habit>> getHabits(String month) async {
    final habits = await storageManager
        .getValue<List<dynamic>>(AppLocalStorageKeys.habitMonth + month);
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
    final habits = await storageManager
        .getValue<List<dynamic>>(AppLocalStorageKeys.habitMonth + month);
    if (habits == null || habits.isEmpty) return [];
    return habits
        .map((habitMap) => Habit.fromJson(habitMap))
        .where((habit) => ((habit.daysStates[date.day] == HabitState.DONE ||
                habit.daysStates[date.day] == HabitState.NOT_DONE) ||
            (habit.repeatDays.contains(DateUtil.getDateDayName(date)) &&
                habit.daysStates[date.day] == HabitState.CREATED)))
        .toList();
  }

  @override
  Future<void> setHabits(List<Habit> habits, String month) async {
    return await storageManager.setValue(AppLocalStorageKeys.habitMonth + month,
        habits.map((habitMap) => habitMap.toJson()).toList());
  }

  @override
  Future<void> addHabit(
      String name, List<String> repeatDays, String month) async {
    final habits = await getHabits(month);
    Map<int, HabitState> daysStates = await _createDaysStates(repeatDays);
    Habit habit = Habit(
        id: NumbersUtil.getRandomId(),
        name: name,
        daysStates: daysStates,
        repeatDays: repeatDays,
        createdDate: DateUtil.getTodayDate());
    habits.add(habit);
    return await setHabits(habits, month);
  }

  Future<Map<int, HabitState>> _createDaysStates(
      List<String> repeatDays) async {
    int monthDaysCount = DateUtil.countDaysOfMonth(DateTime.now());
    Map<int, HabitState> daysStates = {};
    if (monthDaysCount > 0) {
      if (repeatDays.contains(
          DateUtil.getDateDayName(DateUtil.getDateByDay(monthDaysCount)))) {
        daysStates[monthDaysCount] = HabitState.NOT_DONE;
        monthDaysCount--;
      }

      while (monthDaysCount != 0) {
        daysStates[monthDaysCount] = HabitState.CREATED;
        monthDaysCount--;
      }
    }
    return daysStates;
  }

  @override
  Future<int> getHabitIndexById(String habitId, String month) async {
    final habits = await getHabits(month);
    Habit? savedHabit = await getHabitById(habitId, month);
    return savedHabit != null
        ? habits.indexWhere((h) => h.id.compareTo(habitId) == 0)
        : -1;
  }

  @override
  Future<void> updateHabit(Habit habit, String month) async {
    final habits = await getHabits(month);
    final habitIndex = await getHabitIndexById(habit.id, month);
    if (habitIndex > -1) {
      habits[habitIndex] = habit;
      return await setHabits(habits, month);
    }
  }

  @override
  Future<void> updateDayHabits(DateTime day, String month) async {
    bool isInit = await storageManager.getValue<bool>(AppLocalStorageKeys.habitInit + DateUtil.convertDateToString(day)) ?? false;
    if (isInit) return;

    List<Habit> monthHabits = await getHabits(month);
    List<Habit> todayHabits = monthHabits.where((habit) => habit.repeatDays.contains(DateUtil.getDayOfWeekName(day))).toList();
    for (var habit in monthHabits) {
      var monthHabitIndex = await getHabitIndexById(habit.id, month);
      var monthHabit = monthHabits.elementAt(monthHabitIndex);
      if (todayHabits.where((habit) => habit.id == monthHabit.id).isNotEmpty) {
        if (!monthHabit.daysStates.containsKey(day.day)) {
          monthHabit.daysStates[day.day] = HabitState.NOT_DONE;
        } else {
          monthHabit.daysStates[day.day] = HabitState.CREATED;
        }
      }
    }

    await setHabits(monthHabits, month);
    await storageManager.setValue(AppLocalStorageKeys.habitInit + DateUtil.convertDateToString(day), true);
  }

  @override
  Future<bool> isMonthHabitsInit(String month) async {
    return await storageManager.getValue<bool>(AppLocalStorageKeys.habitMonthInit + month) ?? false;
  }

  @override
  Future<void> moveMonthHabits(String lastMonth, String currentMonth, bool value) async {
    bool isInit = await storageManager.getValue<bool>(AppLocalStorageKeys.habitMonthInit + currentMonth) ?? false;
    if (!isInit && value) {
      List<Habit> lastMonthHabits = await getHabits(lastMonth);
      for (var habit in lastMonthHabits) {
        await addHabit(habit.name, habit.repeatDays, currentMonth);
      }
    }
    await storageManager.setValue(AppLocalStorageKeys.habitMonthInit + currentMonth, true);
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
    if (habit.daysStates[day] == HabitState.DONE) {
      habit.daysStates[day] = HabitState.NOT_DONE;
    } else {
      habit.daysStates[day] = HabitState.DONE;
    }
    return await updateHabit(habit, month);
  }

  @override
  Future<void> suspendHabit(Habit habit, int day, String month) async {
    final habits = await getHabits(month);
    final habitIndex = await getHabitIndexById(habit.id, month);
    if (habitIndex > -1) {
      final savedHabit = habits[habitIndex];
      if (savedHabit.repeatDays.contains(DateUtil.getDateDayName(DateUtil.getDateByDay(day)))) {
        savedHabit.daysStates[day] = HabitState.SUSPENDED;
      } else {
        savedHabit.daysStates[day] = HabitState.CREATED;
      }
      return await updateHabit(savedHabit, month);
    }
  }

  @override
  Future<void> unsuspendHabit(Habit habit, int day, String month) async {
    final habits = await getHabits(month);
    final habitIndex = await getHabitIndexById(habit.id, month);
    if (habitIndex > -1) {
      final savedHabit = habits[habitIndex];
      savedHabit.daysStates[day] = HabitState.NOT_DONE;
      return await updateHabit(savedHabit, month);
    }
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
