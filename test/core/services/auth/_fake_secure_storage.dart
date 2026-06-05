import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

/// In-memory `FlutterSecureStorage` mock that survives reads/writes during a
/// single test. Backed by a `Map<String, String?>`.
///
/// Used by `passcode_service_test.dart`, `app_lock_service_test.dart`, and
/// `auth_migrator_test.dart` to validate that PIN hashes + lockout state
/// persist as expected (including across simulated app kill — same map,
/// fresh service instance).
class FakeSecureStorage extends Mock implements FlutterSecureStorage {
  final Map<String, String?> store = <String, String?>{};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    store[key] = value;
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    store.remove(key);
  }
}
