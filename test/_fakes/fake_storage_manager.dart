import 'dart:convert';

import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';

/// Canonical in-memory [IStorageManager] used by every data-layer test. See
/// `docs/scheduler/architecture.md` §10 / §12.7 — the project ships no
/// mocking framework, and this fake is the one shared piece of test
/// infrastructure.
///
/// The on-disk format is "the value passed to `setValue` is JSON-encoded
/// into [store] as a string", matching the real [LocalStorageManager].
class FakeStorageManager implements IStorageManager {
  /// Exposed so tests can seed legacy payloads directly.
  final Map<String, String> store = {};

  @override
  Future<T?> getValue<T>(String key) async {
    final raw = store[key];
    if (raw == null) return null;
    return jsonDecode(raw) as T?;
  }

  @override
  Future setValue(String key, dynamic value) async {
    store[key] = jsonEncode(value);
  }

  @override
  void removeValue(String key) {
    store.remove(key);
  }

  @override
  void clearAll() {
    store.clear();
  }
}
