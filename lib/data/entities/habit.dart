import '../enums/habit_state.dart';

/// Habit entity.
///
/// **Compatibility note (FND-003):** This stays hand-rolled (not Freezed) for
/// source-level parity with the existing legacy screens that construct
/// `Habit(...)` and access `habit.daysStates[day] == HabitState.DONE` directly.
/// The new Freezed model is [HabitEntity] in `habit_entity.dart`; new code
/// (FND-006 ViewModels onwards) should prefer that.
///
/// `toJson` / `fromJson` are tolerant to both the legacy `{<day>:<index:int>}`
/// and modern `{<day>:<wireName:String>}` formats for `daysStates`.
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
        // New writes use wireName; reads tolerate legacy index.
        'daysStates': daysStates
            .map((k, v) => MapEntry(k.toString(), v.wireName)),
        'repeatDays': repeatDays,
        'createdDate': createdDate.toIso8601String(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        createdDate: DateTime.parse(json['createdDate'] as String),
        repeatDays: (json['repeatDays'] as List<dynamic>).cast<String>(),
        daysStates: Map<String, dynamic>.from(json['daysStates'] as Map).map(
          (k, v) => MapEntry(int.parse(k), HabitState.fromJsonDynamic(v)),
        ),
      );
}
