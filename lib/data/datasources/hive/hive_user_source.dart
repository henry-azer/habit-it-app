import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../entities/user_entity.dart';

class HiveUserSource {
  Box get _box => Hive.box(HiveBoxKeys.user);

  Future<UserEntity> read() async {
    final raw = _box.get(HiveBoxKeys.userState);
    if (raw == null) return UserEntity.defaults();
    final map = Map<String, dynamic>.from(raw as Map);
    return UserEntity.fromJson(map);
  }

  Future<void> write(UserEntity entity) async {
    await _box.put(HiveBoxKeys.userState, entity.toJson());
  }

  Future<void> clear() async {
    await _box.delete(HiveBoxKeys.userState);
  }
}
