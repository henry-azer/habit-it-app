import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'i_storage_manager.dart';

class LocalStorageManager extends IStorageManager {
  LocalStorageManager();

  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    String? value = (await _prefs()).getString(key);
    return value != null ? jsonDecode(value) : null;
  }

  @override
  Future setValue(String key, dynamic value) async {
    await (await _prefs()).setString(key, jsonEncode(value));
  }

  @override
  void removeValue(String key) {
    _prefs().then((SharedPreferences pref) => pref.remove(key));
  }

  @override
  void clearAll() {
    _prefs().then((SharedPreferences pref) => pref.clear());
  }
}
