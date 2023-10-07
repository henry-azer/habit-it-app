import 'package:habit_it/data/entities/habit_progress.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../core/utils/date_util.dart';
import '../../entities/habit_stats.dart';
import 'habit_local_datasource.dart';

abstract class HabitStatsLocalDataSource {
  Future<List<HabitStats>> getCurrentMonthHabitsStats();

  Future<List<HabitProgress>> getMonthHabitsProgress(String month);
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
    DateTime firstDayOfMonth = DateUtil.getFirstDayOfMonth(monthDate);
    DateTime today = DateUtil.getTodayDate();

    for (String habit in monthHabits) {
      Map<int, bool> habitValues = {};
      while (firstDayOfMonth.isBefore(today) || firstDayOfMonth.isAtSameMomentAs(today)) {
        String currentDay = DateUtil.convertDateToString(firstDayOfMonth);
        habitValues[firstDayOfMonth.day] = await habitLocalDataSource.getIsHabitDone(habit, currentMonth, currentDay);
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
  Future<List<HabitProgress>> getMonthHabitsProgress(String month) async {
    List<String> monthHabits = await habitLocalDataSource.getAllMonthHabitsForMonth(month);
    List<HabitProgress> monthHabitsProgress = [];

    DateTime monthDate = DateUtil.convertMonthStringToDate(month);
    int monthDaysCount = DateUtil.countDaysOfMonth(monthDate);
    DateTime firstDayOfMonth = DateUtil.getFirstDayOfMonth(monthDate);
    DateTime lastDayOfMonth = DateUtil.getLastDayOfMonth(monthDate);

    for (String habit in monthHabits) {
      Map<int, bool> habitValues = {};
      while (firstDayOfMonth.isBefore(lastDayOfMonth) || firstDayOfMonth.isAtSameMomentAs(lastDayOfMonth)) {
        String currentDay = DateUtil.convertDateToString(firstDayOfMonth);
        habitValues[firstDayOfMonth.day] = await habitLocalDataSource.getIsHabitDone(habit, month, currentDay);
        firstDayOfMonth = firstDayOfMonth.add(const Duration(days: 1));
      }
      int doneCount = 0;
      for (var value in habitValues.values) {
        if (value == true) {
          doneCount++;
        }
      }
      monthHabitsProgress.add(HabitProgress(habit, monthDaysCount, doneCount, habitValues));
    }

    return monthHabitsProgress;
  }
}
