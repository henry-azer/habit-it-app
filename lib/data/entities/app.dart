class App {
  final bool isInitialized;
  final String version;
  final DateTime lastAccessDate;
  final String themeMode;

  // Habit-specific fields (preserved)
  final String initDate;
  final String lastDate;

  const App({
    required this.isInitialized,
    required this.version,
    required this.lastAccessDate,
    required this.themeMode,
    this.initDate = "",
    this.lastDate = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'isInitialized': isInitialized,
      'version': version,
      'lastAccessDate': lastAccessDate.toIso8601String(),
      'themeMode': themeMode,
      'initDate': initDate,
      'lastDate': lastDate,
    };
  }

  factory App.fromMap(Map<String, dynamic> map) {
    return App(
      isInitialized: map['isInitialized'] ?? false,
      version: map['version'] ?? '1.0.0',
      lastAccessDate: DateTime.parse(map['lastAccessDate'] ?? DateTime.now().toIso8601String()),
      themeMode: map['themeMode'] ?? 'system',
      initDate: map['initDate'] ?? "",
      lastDate: map['lastDate'] ?? "",
    );
  }

  App copyWith({
    bool? isInitialized,
    String? version,
    DateTime? lastAccessDate,
    String? themeMode,
    String? initDate,
    String? lastDate,
  }) {
    return App(
      isInitialized: isInitialized ?? this.isInitialized,
      version: version ?? this.version,
      lastAccessDate: lastAccessDate ?? this.lastAccessDate,
      themeMode: themeMode ?? this.themeMode,
      initDate: initDate ?? this.initDate,
      lastDate: lastDate ?? this.lastDate,
    );
  }
}
