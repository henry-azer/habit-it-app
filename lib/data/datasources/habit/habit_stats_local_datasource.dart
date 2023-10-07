import 'package:habit_it/data/entities/habit_progress.dart';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../core/utils/date_util.dart';
import 'habit_local_datasource.dart';

abstract class HabitStatsLocalDataSource {
  Future<List<HabitProgress>> getMonthHabitsProgress(String month);
}

class HabitStatsLocalDataSourceImpl implements HabitStatsLocalDataSource {
  final HabitLocalDataSource habitLocalDataSource;
  final IStorageManager storageManager;

  HabitStatsLocalDataSourceImpl(
      {required this.storageManager, required this.habitLocalDataSource});

  @override
  Future<List<HabitProgress>> getMonthHabitsProgress(String month) async {
    List<String> monthHabits = await habitLocalDataSource.getAllMonthHabitsForMonth(month);
    List<HabitProgress> monthHabitsProgress = [];

    DateTime monthDate = DateUtil.convertMonthStringToDate(month);
    DateTime firstDayOfMonth = DateUtil.getFirstDayOfMonth(monthDate);
    DateTime lastDayOfMonth = DateUtil.getLastDayOfMonth(monthDate);

    for (String habit in monthHabits) {
      Map<int, bool> habitValues = {};
      while (firstDayOfMonth.isBefore(lastDayOfMonth) || firstDayOfMonth.isAtSameMomentAs(lastDayOfMonth)) {
        String currentDay = DateUtil.convertDateToString(firstDayOfMonth);
        habitValues[firstDayOfMonth.day] = await habitLocalDataSource.getIsHabitDone(habit, month, currentDay);
        firstDayOfMonth = firstDayOfMonth.add(const Duration(days: 1));
      }
      monthHabitsProgress.add(HabitProgress(habit, habitValues));
    }

    return monthHabitsProgress;
  }
}
