import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/dtos/habit_progress.dart';

import '../../dtos/habit_stats.dart';
import '../../entities/habit.dart';
import '../../enums/habit_state.dart';

abstract class HabitStatsLocalDataSource {
  Future<List<HabitStats>> getHabitsStatsByMonth(String month);

  Future<List<HabitProgress>> getHabitsProgressByMonth(String month);
}

class HabitStatsLocalDataSourceImpl implements HabitStatsLocalDataSource {
  final IStorageManager storageManager;

  HabitStatsLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<HabitStats>> getHabitsStatsByMonth(String month) async {
    final habits = await _getHabitsByMonth(month);
    return habits.map(_createHabitStats).toList();
  }

  @override
  Future<List<HabitProgress>> getHabitsProgressByMonth(String month) async {
    final habits = await _getHabitsByMonth(month);
    return habits.map(_createHabitProgress).toList();
  }

  HabitStats _createHabitStats(Habit habit) {
    final total = _calculateTotal(habit);
    final totalDone = _calculateTotalDone(habit);
    return HabitStats(
        id: habit.id, name: habit.name, total: total, totalDone: totalDone);
  }

  HabitProgress _createHabitProgress(Habit habit) {
    final total = _calculateTotal(habit);
    final totalDone = _calculateTotalDone(habit);
    return HabitProgress(
      id: habit.id,
      name: habit.name,
      total: total,
      totalDone: totalDone,
      daysStates: habit.daysStates,
    );
  }

  int _calculateTotal(Habit habit) {
    return habit.daysStates.values
        .where(
            (state) => state == HabitState.DONE || state == HabitState.NOT_DONE)
        .length;
  }

  int _calculateTotalDone(Habit habit) {
    return habit.daysStates.values
        .where((state) => state == HabitState.DONE)
        .length;
  }

  Future<List<Habit>> _getHabitsByMonth(String month) async {
    final monthHabits = await storageManager
        .getValue<List<dynamic>>(AppLocalStorageKeys.habitMonth + month);
    return monthHabits?.map((habitMap) => Habit.fromJson(habitMap)).toList() ??
        [];
  }
}
