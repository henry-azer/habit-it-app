import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/habit_stats_entity.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/repositories/i_habit_stats_repository.dart';

/// FND-006 skeleton — full implementation pending ENG-004 / ENG-008.
class StatsHubViewModel {
  StatsHubViewModel({IHabitStatsRepository? statsRepo})
      : _statsRepo = statsRepo ?? getIt<IHabitStatsRepository>();

  final IHabitStatsRepository _statsRepo;

  final BehaviorSubject<HabitStatsEntity?> stats$ =
      BehaviorSubject.seeded(null);

  Future<void> load(MonthKey month) async {
    final r = await _statsRepo.statsForMonth(month);
    r.when(
      ok: (s) {
        if (!stats$.isClosed) stats$.add(s);
      },
      err: (_) {},
    );
  }

  void dispose() {
    stats$.close();
  }
}
