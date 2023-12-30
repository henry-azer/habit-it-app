class Habit {
  late String id;
  late String name;
  late int total;
  late int totalDone;
  late Map<int, bool> values;

  Habit({
    this.id = "",
    this.name = "",
    this.total = 0,
    this.totalDone = 0,
    this.values = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total': total,
      'totalDone': totalDone,
      'values': values,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      total: json['total'] ?? 0,
      totalDone: json['totalDone'] ?? 0,
      values: (json['values'] as Map<String, dynamic>).map<int, bool>(
        (key, value) => MapEntry(int.parse(key), value as bool),
      ),
    );
  }
}
