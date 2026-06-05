import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../entities/habit_note.dart';

class HiveNotesSource {
  Box get _box => Hive.box(HiveBoxKeys.notes);

  String _key(String habitId, DateTime d) =>
      '$habitId/${d.year}-${d.month}-${d.day}';

  Future<HabitNote?> read(String habitId, DateTime date) async {
    final raw = _box.get(_key(habitId, date));
    if (raw == null) return null;
    return HabitNote.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> write(HabitNote note) async {
    await _box.put(_key(note.habitId, note.date), note.toJson());
  }

  Future<void> delete(String habitId, DateTime date) async {
    await _box.delete(_key(habitId, date));
  }

  Future<List<HabitNote>> listForHabit(String habitId) async {
    final notes = <HabitNote>[];
    for (final key in _box.keys) {
      if (key is String && key.startsWith('$habitId/')) {
        final raw = _box.get(key);
        if (raw != null) {
          notes.add(HabitNote.fromJson(Map<String, dynamic>.from(raw as Map)));
        }
      }
    }
    return notes;
  }
}
