import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_progress_entity.freezed.dart';
part 'habit_progress_entity.g.dart';

/// Quantitative progress for one habit on one day (UX-001).
@freezed
sealed class HabitProgressEntity with _$HabitProgressEntity {
  const factory HabitProgressEntity({
    required String habitId,
    required int day,
    required int count,
  }) = _HabitProgressEntity;

  factory HabitProgressEntity.fromJson(Map<String, dynamic> json) =>
      _$HabitProgressEntityFromJson(json);
}
