import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/habit_note.dart';
import '../../repositories/i_notes_repository.dart';
import '../hive/hive_notes_source.dart';

class NotesRepositoryImpl implements INotesRepository {
  NotesRepositoryImpl(this._source);
  final HiveNotesSource _source;

  @override
  Future<Result<HabitNote?>> getNote(String habitId, DateTime date) async {
    try {
      return Ok(await _source.read(habitId, date));
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> upsertNote(HabitNote note) async {
    try {
      await _source.write(note);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> deleteNote(String habitId, DateTime date) async {
    try {
      await _source.delete(habitId, date);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<List<HabitNote>>> listForHabit(String habitId) async {
    try {
      return Ok(await _source.listForHabit(habitId));
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }
}
