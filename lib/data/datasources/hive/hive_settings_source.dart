import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../entities/settings_model.dart';

class HiveSettingsSource {
  Box get _box => Hive.box(HiveBoxKeys.settings);

  Future<SettingsModel> read() async {
    final raw = _box.get(HiveBoxKeys.appSettings);
    if (raw == null) return SettingsModel.defaults();
    final map = Map<String, dynamic>.from(raw as Map);
    return SettingsModel.fromJson(map);
  }

  Future<void> write(SettingsModel m) async {
    await _box.put(HiveBoxKeys.appSettings, m.toJson());
  }
}
