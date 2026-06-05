/// Diagnostic report produced by [SharedPrefsToHiveMigrator].
class MigrationReport {
  MigrationReport({
    this.appMigrated = false,
    this.userMigrated = false,
    this.monthsMigrated = const [],
    this.daysMigrated = const [],
    this.skipped = false,
    this.failed = false,
    this.errorMessage,
    this.errorStack,
    this.legacyKeysCleared = 0,
    this.coercedEmptyRepeatDays = 0,
  });

  factory MigrationReport.empty() => MigrationReport();
  factory MigrationReport.skipped() => MigrationReport(skipped: true);

  bool appMigrated;
  bool userMigrated;
  List<String> monthsMigrated;
  List<String> daysMigrated;
  bool skipped;
  bool failed;
  String? errorMessage;
  StackTrace? errorStack;
  int legacyKeysCleared;

  /// PO G-002 — number of legacy habits with empty `repeatDays` that were
  /// coerced to `HabitSchedule.none()`.
  int coercedEmptyRepeatDays;

  MigrationReport markComplete() => this;
  MigrationReport markFailed(Object e, StackTrace st) {
    failed = true;
    errorMessage = e.toString();
    errorStack = st;
    return this;
  }
}
