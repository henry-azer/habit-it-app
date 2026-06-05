import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_target.freezed.dart';
part 'habit_target.g.dart';

/// Quantitative target for a habit (UX-001).
@freezed
sealed class HabitTarget with _$HabitTarget {
  const factory HabitTarget({
    required int targetCount,
    required String unit, // e.g. "minutes", "pages", "glasses"
  }) = _HabitTarget;

  factory HabitTarget.fromJson(Map<String, dynamic> json) =>
      _$HabitTargetFromJson(json);
}
