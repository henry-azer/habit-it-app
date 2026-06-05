import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/repositories/i_habit_repository.dart';

/// FND-006 skeleton — full implementation lands with SCH-003 (Add Habit
/// redesign). Kept minimal so legacy `AddHabitScreen` keeps working.
class AddHabitViewModel {
  AddHabitViewModel({IHabitRepository? habitRepo})
      : _habitRepo = habitRepo ?? getIt<IHabitRepository>();

  final IHabitRepository _habitRepo;

  final BehaviorSubject<String> name$ = BehaviorSubject.seeded('');
  final BehaviorSubject<List<String>> repeatDays$ =
      BehaviorSubject.seeded(const <String>[]);
  final PublishSubject<bool> savedEvents$ = PublishSubject<bool>();

  Future<void> save({required MonthKey month}) async {
    if (name$.value.isEmpty || repeatDays$.value.isEmpty) {
      savedEvents$.add(false);
      return;
    }
    final r = await _habitRepo.add(
      name: name$.value,
      repeatDays: repeatDays$.value,
      month: month,
    );
    r.when(
      ok: (_) => savedEvents$.add(true),
      err: (_) => savedEvents$.add(false),
    );
  }

  void dispose() {
    name$.close();
    repeatDays$.close();
    savedEvents$.close();
  }
}
