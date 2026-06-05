import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_category.freezed.dart';
part 'habit_category.g.dart';

/// User-defined category for a habit (UX-002).
@freezed
sealed class HabitCategory with _$HabitCategory {
  const factory HabitCategory({
    required String id,
    required String name,
    required String iconName, // FontAwesome icon name
    required String colorHex, // "#RRGGBB"
  }) = _HabitCategory;

  factory HabitCategory.fromJson(Map<String, dynamic> json) =>
      _$HabitCategoryFromJson(json);
}
