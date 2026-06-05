import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';

class HiveMagicMetaSource {
  Box get _box => Hive.box(HiveBoxKeys.magicMeta);

  Future<List<DateTime>> readQuotaLog() async {
    final raw = _box.get(HiveBoxKeys.magicQuotaLog);
    if (raw == null) return [];
    final map = Map<String, dynamic>.from(raw as Map);
    final list = (map['requests'] as List?) ?? const [];
    return list
        .map((e) => DateTime.parse(e as String))
        .toList(growable: false);
  }

  Future<void> writeQuotaLog(List<DateTime> log) async {
    await _box.put(HiveBoxKeys.magicQuotaLog, {
      'requests': log.map((d) => d.toIso8601String()).toList(),
    });
  }

  Future<bool> readCoachPrivacyAck() async {
    return (_box.get(HiveBoxKeys.coachPrivacyAck) as bool?) ?? false;
  }

  Future<void> writeCoachPrivacyAck(bool value) async {
    await _box.put(HiveBoxKeys.coachPrivacyAck, value);
  }
}
