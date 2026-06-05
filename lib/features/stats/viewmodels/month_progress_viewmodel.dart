import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/habit.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/repositories/i_habit_repository.dart';

/// FND-006 skeleton — full implementation pending ENG-008.
class MonthProgressViewModel {
  MonthProgressViewModel({IHabitRepository? habitRepo})
      : _habitRepo = habitRepo ?? getIt<IHabitRepository>();

  final IHabitRepository _habitRepo;

  final BehaviorSubject<List<Habit>> habits$ =
      BehaviorSubject.seeded(const <Habit>[]);

  Future<void> load(DateTime month) async {
    final r = await _habitRepo.getByMonth(MonthKey.fromDateTime(month));
    r.when(
      ok: (list) {
        if (!habits$.isClosed) habits$.add(list);
      },
      err: (_) {},
    );
  }

  void dispose() => habits$.close();
}
