import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_suggestion.freezed.dart';
part 'habit_suggestion.g.dart';

/// AI-generated habit suggestion (AI-006). In-memory only — never persisted.
@freezed
sealed class HabitSuggestion with _$HabitSuggestion {
  const factory HabitSuggestion({
    required String title,
    required String description,
    @Default(<String>[]) List<String> suggestedWeekdays,
  }) = _HabitSuggestion;

  factory HabitSuggestion.fromJson(Map<String, dynamic> json) =>
      _$HabitSuggestionFromJson(json);
}
