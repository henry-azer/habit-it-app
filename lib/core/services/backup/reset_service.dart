import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/hive_box_keys.dart';
import '../../constants/secure_storage_keys.dart';

/// AUTH-006 — wipe all app data after explicit user confirm on the
/// "Forgot PIN?" flow.
///
/// **Scope of the wipe (TS-AUTH-006):**
///   1. Whitelisted Hive boxes — closed if open, then deleted from disk.
///      The caller is responsible for re-opening them after `resetAll`
///      returns (typically by routing back to `/` which restarts main()).
///   2. Known FSS keys — deleted individually (NOT `deleteAll()`; other
///      Flutter plugins may use FSS too and we mustn't clobber them).
///   3. Legacy SharedPreferences keys with the `APP/` prefix — defensively
///      removed so the migrator can't re-populate Hive from stale data on
///      the next launch.
class ResetService {
  ResetService(this._secureStorage, this._sharedPrefs);

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPrefs;

  static const _hiveBoxes = <String>[
    HiveBoxKeys.app,
    HiveBoxKeys.user,
    HiveBoxKeys.settings,
    HiveBoxKeys.habits,
    HiveBoxKeys.notes,
    HiveBoxKeys.notificationsMeta,
    HiveBoxKeys.magicMeta,
  ];

  static const _fssKeys = <String>[
    SecureStorageKeys.pinHash,
    SecureStorageKeys.failedAttempts,
    SecureStorageKeys.lockoutUntil,
    SecureStorageKeys.magicGroqApiKey,
  ];

  Future<void> resetAll() async {
    // 1. Hive — close + delete on disk. Re-opening is the caller's job
    //    (main.dart re-opens on next bootstrap).
    for (final name in _hiveBoxes) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).close();
      }
      await Hive.deleteBoxFromDisk(name);
    }

    // 2. Secure storage — known-key deletion only. Never `deleteAll()`.
    for (final key in _fssKeys) {
      await _secureStorage.delete(key: key);
    }

    // 3. Legacy SharedPreferences — defensively clear `APP/` keys so any
    //    future migrator run can't restore stale data.
    final keys = _sharedPrefs.getKeys().toList();
    for (final key in keys) {
      if (key.startsWith('APP/')) {
        await _sharedPrefs.remove(key);
      }
    }
  }
}
