import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../repositories/i_notification_repository.dart';

class HiveNotificationMetaSource {
  Box get _box => Hive.box(HiveBoxKeys.notificationsMeta);

  Future<NotificationMeta?> read(String habitId) async {
    final raw = _box.get(habitId);
    if (raw == null) return null;
    return NotificationMeta.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> write(NotificationMeta meta) async {
    await _box.put(meta.habitId, meta.toJson());
  }

  Future<void> delete(String habitId) async {
    await _box.delete(habitId);
  }
}
