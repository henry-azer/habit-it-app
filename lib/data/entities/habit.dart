class Habit {
  late String id;
  late String name;
  late int total;
  late int totalDone;
  late Map<int, bool> values;
  late List<String> repeatDays;
  late DateTime createdDate;

  Habit({
    required this.id,
    required this.name,
    required this.total,
    required this.totalDone,
    required this.values,
    required this.repeatDays,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'total': total,
    'totalDone': totalDone,
    'values': values.map((key, value) => MapEntry(key.toString(), value)),
    'repeatDays': repeatDays,
    'createdDate': createdDate.toIso8601String(),
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    name: json['name'] as String,
    total: json['total'] as int,
    totalDone: json['totalDone'] as int,
    createdDate: DateTime.parse(json['createdDate'] as String),
    repeatDays: (json['repeatDays'] as List<dynamic>).cast<String>(),
    values: (json['values'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value as bool),
    ),
  );
}
