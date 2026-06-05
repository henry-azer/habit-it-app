import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../entities/app_entity.dart';

class HiveAppSource {
  Box get _box => Hive.box(HiveBoxKeys.app);

  Future<AppEntity> read() async {
    final raw = _box.get(HiveBoxKeys.appState);
    if (raw == null) return AppEntity.defaults();
    final map = Map<String, dynamic>.from(raw as Map);
    return AppEntity.fromJson(map);
  }

  Future<void> write(AppEntity entity) async {
    await _box.put(HiveBoxKeys.appState, entity.toJson());
  }

  Future<void> clear() async {
    await _box.delete(HiveBoxKeys.appState);
  }
}
