import '../enums/habit_state.dart';

class HabitProgress {
  late String id;
  late String name;
  late int total;
  late int totalDone;
  late Map<int, HabitState> daysStates;

  HabitProgress({
    required this.id,
    required this.name,
    required this.total,
    required this.totalDone,
    required this.daysStates,
  });
}
