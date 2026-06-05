import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';

import '../../../core/extensions/date_time_x.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/habit.dart';
import '../../entities/month_key.dart';
import '../../enums/habit_state.dart';
import '../../repositories/i_habit_repository.dart';
import '../hive/hive_habit_source.dart';

/// Habit repository — Hive-backed, preserves all legacy behaviors of the old
/// `HabitLocalDataSourceImpl` (toggle / suspend / unsuspend / month carry /
/// day init).
class HabitRepositoryImpl implements IHabitRepository {
  HabitRepositoryImpl(this._source);
  final HiveHabitSource _source;

  /// Per-month BehaviorSubjects, lazily allocated.
  final Map<String, BehaviorSubject<List<Habit>>> _streams = {};
  Future<void> _serial = Future.value();

  BehaviorSubject<List<Habit>> _streamFor(MonthKey month) {
    return _streams.putIfAbsent(month.key, () => BehaviorSubject<List<Habit>>());
  }

  @override
  Stream<List<Habit>> watchByMonth(MonthKey month) => _streamFor(month);

  @override
  Future<Result<List<Habit>>> getByMonth(MonthKey month) async {
    try {
      final habits = await _source.getMonth(month);
      final s = _streamFor(month);
      if (!s.isClosed) s.add(habits);
      return Ok(habits);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<List<Habit>>> getByDay(DateTime day) async {
    try {
      final month = MonthKey.fromDateTime(day);
      final habits = await _source.getMonth(month);
      final filtered = habits
          .where((habit) =>
              (habit.daysStates[day.day] == HabitState.DONE ||
                  habit.daysStates[day.day] == HabitState.NOT_DONE) ||
              (habit.repeatDays.contains(day.weekdayName) &&
                  habit.daysStates[day.day] == HabitState.CREATED))
          .toList();
      return Ok(filtered);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<Habit?>> getById(String id, MonthKey month) async {
    try {
      final habits = await _source.getMonth(month);
      try {
        return Ok(habits.firstWhere((h) => h.id == id));
      } on StateError {
        return const Ok(null);
      }
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  Future<Result<void>> _mutateMonth(
    MonthKey month,
    Future<List<Habit>> Function(List<Habit> current) f,
  ) {
    final completer = Completer<Result<void>>();
    _serial = _serial.then((_) async {
      try {
        final current = await _source.getMonth(month);
        final next = await f(current);
        await _source.putMonth(month, next);
        final s = _streamFor(month);
        if (!s.isClosed) s.add(next);
        completer.complete(const Ok(null));
      } catch (e, st) {
        completer.complete(Err(StorageFailure(e.toString(), st)));
      }
    });
    return completer.future;
  }

  @override
  Future<Result<void>> add({
    required String name,
    required List<String> repeatDays,
    required MonthKey month,
  }) {
    return _mutateMonth(month, (habits) async {
      final id = _randomId();
      final daysStates = _createDaysStates(repeatDays);
      habits.add(Habit(
        id: id,
        name: name,
        daysStates: daysStates,
        repeatDays: repeatDays,
        createdDate: DateTime.now(),
      ));
      return habits;
    });
  }

  @override
  Future<Result<void>> update(Habit habit, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      final i = habits.indexWhere((h) => h.id == habit.id);
      if (i >= 0) habits[i] = habit;
      return habits;
    });
  }

  @override
  Future<Result<void>> delete(Habit habit, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      habits.removeWhere((h) => h.id == habit.id);
      return habits;
    });
  }

  @override
  Future<Result<void>> reorder(Habit a, Habit b, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      final oldIdx = habits.indexWhere((h) => h.id == a.id);
      final newIdx = habits.indexWhere((h) => h.id == b.id);
      if (oldIdx > -1 && newIdx > -1) {
        final item = habits.removeAt(oldIdx);
        habits.insert(newIdx, item);
      }
      return habits;
    });
  }

  @override
  Future<Result<void>> toggle(Habit habit, int day, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      final i = habits.indexWhere((h) => h.id == habit.id);
      if (i < 0) return habits;
      final h = habits[i];
      if (h.daysStates[day] == HabitState.DONE) {
        h.daysStates[day] = HabitState.NOT_DONE;
      } else {
        h.daysStates[day] = HabitState.DONE;
      }
      habits[i] = h;
      return habits;
    });
  }

  @override
  Future<Result<void>> suspend(Habit habit, int day, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      final i = habits.indexWhere((h) => h.id == habit.id);
      if (i < 0) return habits;
      final h = habits[i];
      final dayName = DateTime(month.year, month.month, day).weekdayName;
      if (h.repeatDays.contains(dayName)) {
        h.daysStates[day] = HabitState.SUSPENDED;
      } else {
        h.daysStates[day] = HabitState.CREATED;
      }
      habits[i] = h;
      return habits;
    });
  }

  @override
  Future<Result<void>> unsuspend(Habit habit, int day, MonthKey month) {
    return _mutateMonth(month, (habits) async {
      final i = habits.indexWhere((h) => h.id == habit.id);
      if (i < 0) return habits;
      final h = habits[i];
      h.daysStates[day] = HabitState.NOT_DONE;
      habits[i] = h;
      return habits;
    });
  }

  @override
  Future<Result<void>> initDayIfNeeded(DateTime day, MonthKey month) async {
    try {
      if (await _source.isDayInit(day)) return const Ok(null);

      await _mutateMonth(month, (habits) async {
        final todayHabits = habits
            .where((h) => h.repeatDays.contains(day.weekdayName))
            .toList();
        for (final habit in habits) {
          if (todayHabits.any((h) => h.id == habit.id)) {
            if (!habit.daysStates.containsKey(day.day)) {
              habit.daysStates[day.day] = HabitState.NOT_DONE;
            } else {
              habit.daysStates[day.day] = HabitState.CREATED;
            }
          }
        }
        return habits;
      });

      await _source.setDayInit(day, true);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<bool> isMonthInit(MonthKey month) => _source.isMonthInit(month);

  @override
  Future<Result<void>> moveMonth({
    required MonthKey from,
    required MonthKey to,
    required bool carryForward,
  }) async {
    try {
      final isInit = await _source.isMonthInit(to);
      if (!isInit && carryForward) {
        final lastMonthHabits = await _source.getMonth(from);
        for (final habit in lastMonthHabits) {
          await add(name: habit.name, repeatDays: habit.repeatDays, month: to);
        }
      }
      await _source.setMonthInit(to, true);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> setStateForDay({
    required String habitId,
    required int day,
    required MonthKey month,
    required HabitState state,
  }) {
    return _mutateMonth(month, (habits) async {
      final i = habits.indexWhere((h) => h.id == habitId);
      if (i < 0) return habits;
      final h = habits[i];
      h.daysStates[day] = state;
      habits[i] = h;
      return habits;
    });
  }

  // ---- Helpers ----

  static final Random _random = Random();
  static String _randomId() {
    final ts = DateTime.now().microsecondsSinceEpoch.toString();
    final rnd = _random.nextInt(0xFFFFFFFF).toRadixString(16);
    return '$ts-$rnd';
  }

  Map<int, HabitState> _createDaysStates(List<String> repeatDays) {
    final now = DateTime.now();
    final monthDaysCount = _countDaysOfMonth(now);
    final daysStates = <int, HabitState>{};
    var day = monthDaysCount;
    if (day > 0) {
      final lastDate = DateTime(now.year, now.month, day);
      if (repeatDays.contains(lastDate.weekdayName)) {
        daysStates[day] = HabitState.NOT_DONE;
        day--;
      }
      while (day != 0) {
        daysStates[day] = HabitState.CREATED;
        day--;
      }
    }
    return daysStates;
  }

  int _countDaysOfMonth(DateTime d) {
    final next = DateTime(d.year, d.month + 1, 0);
    return next.day;
  }
}
