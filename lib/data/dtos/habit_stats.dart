class HabitStats {
  late String id;
  late String name;
  late int total;
  late int totalDone;

  HabitStats({
    required this.id,
    required this.name,
    required this.total,
    required this.totalDone,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'total': total,
    'totalDone': totalDone,
  };

  factory HabitStats.fromJson(Map<String, dynamic> json) => HabitStats(
    id: json['id'] as String,
    name: json['name'] as String,
    total: json['total'] as int,
    totalDone: json['totalDone'] as int,
  );
}
