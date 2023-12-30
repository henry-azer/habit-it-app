import 'package:habit_it/data/entities/habit.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../core/utils/date_util.dart';
import '../../entities/habit_stats.dart';
import 'habit_local_datasource.dart';

abstract class HabitStatsLocalDataSource {
  Future<List<HabitStats>> getCurrentMonthHabitsStats();

  Future<List<Habit>> getMonthHabitsProgress(String month);
}

class HabitStatsLocalDataSourceImpl implements HabitStatsLocalDataSource {
  final HabitLocalDataSource habitLocalDataSource;
  final IStorageManager storageManager;

  HabitStatsLocalDataSourceImpl(
      {required this.storageManager, required this.habitLocalDataSource});

  @override
  Future<List<HabitStats>> getCurrentMonthHabitsStats() async {
    String currentMonth = DateUtil.getCurrentMonthDateString();
    List<String> monthHabits = await habitLocalDataSource.getAllMonthHabitsForMonth(currentMonth);
    List<HabitStats> monthHabitsStats = [];

    DateTime monthDate = DateUtil.convertMonthStringToDate(currentMonth);
    int monthDaysCount = DateUtil.countDaysOfMonthUntilToday(monthDate);

    for (String habit in monthHabits) {
      Map<int, bool> habitValues = {};
      DateTime firstDayOfMonth = DateUtil.getFirstDayOfMonth(monthDate);
      DateTime today = DateUtil.getTodayDate();
      while (firstDayOfMonth.isBefore(today) || firstDayOfMonth.isAtSameMomentAs(today)) {
        String currentDay = DateUtil.convertDateToString(firstDayOfMonth);
        bool isDone = await habitLocalDataSource.getIsHabitDone(habit, currentMonth, currentDay);
        habitValues[firstDayOfMonth.day] = isDone;
        firstDayOfMonth = firstDayOfMonth.add(const Duration(days: 1));
      }
      int doneCount = 0;
      for (var value in habitValues.values) {
        if (value == true) {
          doneCount++;
        }
      }
      monthHabitsStats.add(HabitStats(habit, monthDaysCount, doneCount));
    }

    return monthHabitsStats;
  }

  @override
  Future<List<Habit>> getMonthHabitsProgress(String month) async {
    List<String> monthHabits = await habitLocalDataSource.getAllMonthHabitsForMonth(month);
    List<Habit> monthHabitsProgress = [];

    DateTime monthDate = DateUtil.convertMonthStringToDate(month);
    int monthDaysCount = DateUtil.countDaysOfMonth(monthDate);

    for (String habit in monthHabits) {
      Map<int, bool> habitValues = {};
      DateTime firstDayOfMonth = DateUtil.getFirstDayOfMonth(monthDate);
      DateTime lastDayOfMonth = DateUtil.getLastDayOfMonth(monthDate);
      while (firstDayOfMonth.isBefore(lastDayOfMonth) || firstDayOfMonth.isAtSameMomentAs(lastDayOfMonth)) {
        String currentDay = DateUtil.convertDateToString(firstDayOfMonth);
        bool isDone = await habitLocalDataSource.getIsHabitDone(habit, month, currentDay);
        habitValues[firstDayOfMonth.day] = isDone;
        firstDayOfMonth = firstDayOfMonth.add(const Duration(days: 1));
      }
      int doneCount = 0;
      for (var value in habitValues.values) {
        if (value == true) {
          doneCount++;
        }
      }
      // todo
      // monthHabitsProgress.add(Habit("s", habit, monthDaysCount, doneCount, habitValues));
    }

    return monthHabitsProgress;
  }
}
