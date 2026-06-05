import '../../core/utils/result.dart';

/// Per-habit notification metadata persisted in the `notifications_meta` Hive
/// box. SCH-002 and ENG-006 use this for cancel-by-habit and tap-routing.
class NotificationMeta {
  const NotificationMeta({
    required this.habitId,
    required this.notificationId,
    required this.lastScheduledForIso,
  });
  final String habitId;
  final int notificationId;
  final String lastScheduledForIso;

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'notificationId': notificationId,
        'lastScheduledFor': lastScheduledForIso,
      };

  factory NotificationMeta.fromJson(Map<String, dynamic> j) => NotificationMeta(
        habitId: j['habitId'] as String,
        notificationId: j['notificationId'] as int,
        lastScheduledForIso: j['lastScheduledFor'] as String,
      );
}

abstract class INotificationRepository {
  Future<Result<NotificationMeta?>> getByHabitId(String habitId);
  Future<Result<void>> upsert(NotificationMeta meta);
  Future<Result<void>> deleteByHabitId(String habitId);
}
