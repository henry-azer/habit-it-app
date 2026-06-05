import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/habit.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/repositories/i_habit_repository.dart';

/// FND-006 skeleton — full implementation pending ENG-002 / ENG-003.
class ManageHabitsViewModel {
  ManageHabitsViewModel({IHabitRepository? habitRepo})
      : _habitRepo = habitRepo ?? getIt<IHabitRepository>();

  final IHabitRepository _habitRepo;

  final BehaviorSubject<List<Habit>> habits$ =
      BehaviorSubject.seeded(const <Habit>[]);

  Future<void> load(MonthKey month) async {
    final r = await _habitRepo.getByMonth(month);
    r.when(
      ok: (h) {
        if (!habits$.isClosed) habits$.add(h);
      },
      err: (_) {},
    );
  }

  Future<void> reorder(Habit a, Habit b, MonthKey month) async {
    await _habitRepo.reorder(a, b, month);
    await load(month);
  }

  Future<void> delete(Habit h, MonthKey month) async {
    await _habitRepo.delete(h, month);
    await load(month);
  }

  void dispose() {
    habits$.close();
  }
}
