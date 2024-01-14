import '../enums/habit_state.dart';

class Habit {
  late String id;
  late String name;
  late DateTime createdDate;
  late List<String> repeatDays;
  late Map<int, HabitState> daysStates;

  Habit({
    required this.id,
    required this.name,
    required this.daysStates,
    required this.repeatDays,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'daysStates': daysStates
            .map((key, value) => MapEntry(key.toString(), value.index)),
        'repeatDays': repeatDays,
        'createdDate': createdDate.toIso8601String(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        createdDate: DateTime.parse(json['createdDate'] as String),
        repeatDays: (json['repeatDays'] as List<dynamic>).cast<String>(),
        daysStates: Map.from(json['daysStates']).map(
            (key, value) => MapEntry(int.parse(key), HabitState.values[value])),
      );
}
