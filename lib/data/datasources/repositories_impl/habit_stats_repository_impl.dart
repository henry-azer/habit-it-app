import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/habit.dart';
import '../../entities/habit_stats_entity.dart';
import '../../entities/month_key.dart';
import '../../enums/habit_state.dart';
import '../../repositories/i_habit_stats_repository.dart';
import '../hive/hive_habit_source.dart';

class HabitStatsRepositoryImpl implements IHabitStatsRepository {
  HabitStatsRepositoryImpl(this._source);
  final HiveHabitSource _source;

  @override
  Future<Result<HabitStatsEntity>> statsForHabit(
      Habit habit, MonthKey month) async {
    try {
      return Ok(_computeStats([habit]));
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<HabitStatsEntity>> statsForMonth(MonthKey month) async {
    try {
      final habits = await _source.getMonth(month);
      return Ok(_computeStats(habits));
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  HabitStatsEntity _computeStats(List<Habit> habits) {
    var done = 0, notDone = 0, created = 0, suspended = 0, inProgress = 0;
    for (final h in habits) {
      for (final s in h.daysStates.values) {
        switch (s) {
          case HabitState.DONE:
            done++;
            break;
          case HabitState.NOT_DONE:
            notDone++;
            break;
          case HabitState.CREATED:
            created++;
            break;
          case HabitState.SUSPENDED:
            suspended++;
            break;
          case HabitState.IN_PROGRESS:
            inProgress++;
            break;
        }
      }
    }
    return HabitStatsEntity(
      done: done,
      notDone: notDone,
      created: created,
      suspended: suspended,
      inProgress: inProgress,
    );
  }
}
