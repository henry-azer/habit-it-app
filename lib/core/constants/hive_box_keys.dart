/// Hive box names and well-known key names.
///
/// Single source of truth — every `Hive.openBox(...)` call references a const
/// here. See TECHNICAL_STORIES.md §5 for box → owner mapping.
abstract final class HiveBoxKeys {
  HiveBoxKeys._();

  // Box names
  static const String app = 'app';
  static const String user = 'user';
  static const String settings = 'settings';
  static const String habits = 'habits';
  static const String notes = 'notes';
  static const String notificationsMeta = 'notifications_meta';
  static const String magicMeta = 'magic_meta';

  // Well-known keys inside boxes
  static const String appState = 'app_state';
  static const String userState = 'user_state';
  static const String appSettings = 'app_settings';

  // Habit box key prefixes (per-month + per-day-init + per-month-init)
  static const String habitMonthPrefix = 'month/';
  static const String habitDayInitPrefix = 'day_init/';
  static const String habitMonthInitPrefix = 'month_init/';

  // Magic-meta keys
  static const String magicQuotaLog = 'quota_log';
  static const String coachPrivacyAck = 'coach_privacy_ack';
}
