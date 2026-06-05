import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/habit.dart';
import '../../../data/entities/month_key.dart';
import '../../../data/repositories/i_habit_repository.dart';
import '../../../data/repositories/i_settings_repository.dart';

/// Habit list UI state.
sealed class HabitsUiState {
  const HabitsUiState();
}

class HabitsLoading extends HabitsUiState {
  const HabitsLoading();
}

class HabitsReady extends HabitsUiState {
  const HabitsReady({required this.habits, required this.day});
  final List<Habit> habits;
  final DateTime day;
}

class HabitsEmpty extends HabitsUiState {
  const HabitsEmpty(this.day);
  final DateTime day;
}

class HabitsError extends HabitsUiState {
  const HabitsError(this.message);
  final String message;
}

/// TS-FND-006 scaffold for the Habits list ViewModel.
///
/// Full implementation (selectDay / toggle / suspend / reorder) lands when
/// the legacy `HabitScreen` is rewritten under ENG-002 + ENG-007. For now
/// this VM holds the contract and is registered nowhere — the existing
/// `HabitScreen` still consumes legacy data sources for behavioral parity.
class HabitsViewModel {
  HabitsViewModel({
    IHabitRepository? habitRepo,
    ISettingsRepository? settingsRepo,
    DateTime Function()? now,
  })  : _habitRepo = habitRepo ?? getIt<IHabitRepository>(),
        // ignore: unused_element
        _settingsRepo = settingsRepo ?? getIt<ISettingsRepository>(),
        _now = now ?? DateTime.now;

  final IHabitRepository _habitRepo;
  // ignore: unused_field
  final ISettingsRepository _settingsRepo;
  final DateTime Function() _now;

  final BehaviorSubject<HabitsUiState> state$ =
      BehaviorSubject.seeded(const HabitsLoading());
  final BehaviorSubject<DateTime> selectedDay$ =
      BehaviorSubject.seeded(DateTime.now());

  Future<void> load() async {
    final day = _now();
    selectedDay$.add(day);
    final r = await _habitRepo.getByDay(day);
    r.when(
      ok: (habits) {
        if (state$.isClosed) return;
        if (habits.isEmpty) {
          state$.add(HabitsEmpty(day));
        } else {
          state$.add(HabitsReady(habits: habits, day: day));
        }
      },
      err: (f) {
        if (!state$.isClosed) state$.add(HabitsError(f.message));
      },
    );
  }

  Future<void> selectDay(DateTime d) async {
    selectedDay$.add(d);
    final r = await _habitRepo.getByDay(d);
    r.when(
      ok: (habits) {
        if (state$.isClosed) return;
        state$.add(habits.isEmpty
            ? HabitsEmpty(d)
            : HabitsReady(habits: habits, day: d));
      },
      err: (f) {
        if (!state$.isClosed) state$.add(HabitsError(f.message));
      },
    );
  }

  Future<void> toggle(Habit h) async {
    final day = selectedDay$.value;
    await _habitRepo.toggle(h, day.day, MonthKey.fromDateTime(day));
    await selectDay(day);
  }

  void dispose() {
    state$.close();
    selectedDay$.close();
  }
}
