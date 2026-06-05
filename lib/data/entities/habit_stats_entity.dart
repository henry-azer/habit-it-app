import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_stats_entity.freezed.dart';
part 'habit_stats_entity.g.dart';

/// Aggregate stats for a habit over a month (legacy HabitStats DTO replacement).
@freezed
sealed class HabitStatsEntity with _$HabitStatsEntity {
  const factory HabitStatsEntity({
    required int done,
    required int notDone,
    required int created,
    required int suspended,
    @Default(0) int inProgress,
  }) = _HabitStatsEntity;

  factory HabitStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$HabitStatsEntityFromJson(json);
}
