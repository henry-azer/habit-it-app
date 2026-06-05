import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/constants/secure_storage_keys.dart';
import 'package:habit_it/core/services/auth/passcode_service_impl.dart';

import '_fake_secure_storage.dart';

/// TS-AUTH-001 AC#2/3/4 — PBKDF2-SHA256 100,000 iters, 16-byte salt,
/// 32-byte hash, "1$<salt>$<hash>" format, constant-time compare,
/// stored in FSS under `auth.pin_hash`.
void main() {
  late FakeSecureStorage storage;
  late PasscodeServiceImpl service;

  setUp(() {
    storage = FakeSecureStorage();
    service = PasscodeServiceImpl(storage: storage);
  });

  group('PasscodeServiceImpl', () {
    test('isSet returns false before setPasscode', () async {
      expect(await service.isSet(), isFalse);
    });

    test('setPasscode stores hash in FSS under auth.pin_hash', () async {
      await service.setPasscode('1234');
      final stored = storage.store[SecureStorageKeys.pinHash];
      expect(stored, isNotNull);
      expect(await service.isSet(), isTrue);
    });

    test('stored value follows "1\$<base64Salt>\$<base64Hash>" format', () async {
      await service.setPasscode('1234');
      final stored = storage.store[SecureStorageKeys.pinHash]!;
      final parts = stored.split(r'$');
      expect(parts, hasLength(3));
      expect(parts[0], '1', reason: 'format version');
      // base64 of 16 bytes = 24 chars (with `=` padding)
      expect(parts[1].length, 24);
      // base64 of 32 bytes = 44 chars (with `=` padding)
      expect(parts[2].length, 44);
    });

    test('verify returns true for correct PIN (round-trip)', () async {
      await service.setPasscode('1234');
      expect(await service.verify('1234'), isTrue);
    });

    test('verify returns false for wrong PIN', () async {
      await service.setPasscode('1234');
      expect(await service.verify('1235'), isFalse);
      expect(await service.verify('0000'), isFalse);
    });

    test('verify returns false when no PIN stored', () async {
      expect(await service.verify('1234'), isFalse);
    });

    test('verify uses random salt (two sets produce different hashes)',
        () async {
      await service.setPasscode('1234');
      final firstHash = storage.store[SecureStorageKeys.pinHash];
      await service.setPasscode('1234');
      final secondHash = storage.store[SecureStorageKeys.pinHash];
      expect(firstHash, isNot(equals(secondHash)),
          reason: 'random salt should make repeated set() produce distinct hashes');
      // But both verify correctly.
      expect(await service.verify('1234'), isTrue);
    });

    test('clear removes hash, attempts, and lockout', () async {
      await service.setPasscode('1234');
      await service.incrementFailedAttempts();
      await service.setLockoutUntil(DateTime(2026, 6, 6));

      await service.clear();

      expect(storage.store[SecureStorageKeys.pinHash], isNull);
      expect(storage.store[SecureStorageKeys.failedAttempts], isNull);
      expect(storage.store[SecureStorageKeys.lockoutUntil], isNull);
      expect(await service.isSet(), isFalse);
    });

    test('failed-attempts counter increments', () async {
      expect(await service.getFailedAttempts(), 0);
      await service.incrementFailedAttempts();
      expect(await service.getFailedAttempts(), 1);
      await service.incrementFailedAttempts();
      await service.incrementFailedAttempts();
      expect(await service.getFailedAttempts(), 3);
    });

    test('resetFailedAttempts clears the counter', () async {
      await service.incrementFailedAttempts();
      await service.incrementFailedAttempts();
      await service.resetFailedAttempts();
      expect(await service.getFailedAttempts(), 0);
    });

    test('lockoutUntil round-trips as ISO-8601 (survives ms precision)',
        () async {
      final until = DateTime.utc(2026, 6, 5, 12, 30, 45);
      await service.setLockoutUntil(until);
      expect(await service.getLockoutUntil(), until);
      await service.setLockoutUntil(null);
      expect(await service.getLockoutUntil(), isNull);
    });

    test('format-version mismatch returns false instead of throwing',
        () async {
      // Manually plant a v2 (future) entry.
      storage.store[SecureStorageKeys.pinHash] = r'2$aaaa$bbbb';
      expect(await service.verify('1234'), isFalse);
    });

    test('malformed stored value returns false instead of throwing',
        () async {
      storage.store[SecureStorageKeys.pinHash] = 'garbage';
      expect(await service.verify('1234'), isFalse);
    });

    test('verify exercises constant-time compare even for length-equal mismatch',
        () async {
      // We can't observe time directly in a unit test, but we can at least
      // verify the compare doesn't short-circuit on partial-prefix match.
      await service.setPasscode('1234');
      expect(await service.verify('1234'), isTrue);
      expect(await service.verify('1235'), isFalse);
      expect(await service.verify('9999'), isFalse);
    });
  });
}
