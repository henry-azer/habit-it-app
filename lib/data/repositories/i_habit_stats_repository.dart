import '../entities/habit.dart';
import '../entities/habit_stats_entity.dart';
import '../entities/month_key.dart';
import '../../core/utils/result.dart';

abstract class IHabitStatsRepository {
  Future<Result<HabitStatsEntity>> statsForHabit(Habit habit, MonthKey month);
  Future<Result<HabitStatsEntity>> statsForMonth(MonthKey month);
}
