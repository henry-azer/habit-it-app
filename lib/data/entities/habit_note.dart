import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_note.freezed.dart';
part 'habit_note.g.dart';

/// One free-text note attached to a habit check-in (ENG-005).
@freezed
sealed class HabitNote with _$HabitNote {
  const factory HabitNote({
    required String habitId,
    required DateTime date,
    required String text,
  }) = _HabitNote;

  factory HabitNote.fromJson(Map<String, dynamic> json) =>
      _$HabitNoteFromJson(json);
}
