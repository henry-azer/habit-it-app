import '../entities/habit_note.dart';
import '../../core/utils/result.dart';

abstract class INotesRepository {
  Future<Result<HabitNote?>> getNote(String habitId, DateTime date);
  Future<Result<void>> upsertNote(HabitNote note);
  Future<Result<void>> deleteNote(String habitId, DateTime date);
  Future<Result<List<HabitNote>>> listForHabit(String habitId);
}
