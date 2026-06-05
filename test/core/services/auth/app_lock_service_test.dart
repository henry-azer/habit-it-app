import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/managers/biometric/i_biometric_manager.dart';
import 'package:habit_it/core/services/auth/app_lock_service.dart';
import 'package:habit_it/core/services/auth/passcode_service_impl.dart';
import 'package:habit_it/core/services/auth/unlock_result.dart';
import 'package:mocktail/mocktail.dart';

import '_fake_secure_storage.dart';

/// Test double for `IBiometricManager`. Default: available + authenticate=true
/// (so positive tests don't need to set up expectations).
class _FakeBiometricManager implements IBiometricManager {
  bool available;
  bool authResult;
  _FakeBiometricManager({this.available = true, this.authResult = true});

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate({required String reason, bool stickyAuth = true}) async =>
      authResult;
}

/// TS-AUTH-005 — lockout policy (5 → 30 s, 10 → 5 min), survives app kill,
/// lockedNotifier toggles on lockNow / unlockNow / verifyPasscode-success.
void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  late FakeSecureStorage storage;
  late PasscodeServiceImpl passcode;
  late _FakeBiometricManager biometric;
  late AppLockService lock;
  bool _disposed = false;

  setUp(() async {
    storage = FakeSecureStorage();
    passcode = PasscodeServiceImpl(storage: storage);
    biometric = _FakeBiometricManager();
    lock = AppLockService(passcode: passcode, biometric: biometric);
    _disposed = false;
    await passcode.setPasscode('1234');
  });

  tearDown(() {
    if (!_disposed) lock.dispose();
  });

  group('verifyPasscode', () {
    test('correct PIN returns UnlockSuccess and flips notifier to false',
        () async {
      lock.lockNow();
      expect(lock.lockedNotifier.value, isTrue);
      final result = await lock.verifyPasscode('1234');
      expect(result, isA<UnlockSuccess>());
      expect(lock.lockedNotifier.value, isFalse);
      expect(await passcode.getFailedAttempts(), 0,
          reason: 'success resets attempts counter');
    });

    test('wrong PIN under threshold returns UnlockWrong with remaining count',
        () async {
      final result = await lock.verifyPasscode('9999');
      expect(result, isA<UnlockWrong>());
      final wrong = result as UnlockWrong;
      // _maxAttemptsBeforeShortLockout = 4 (kFirstLockoutAttempt - 1 = 4),
      // attempts is now 1, so remaining = 4 - 1 = 3.
      expect(wrong.attemptsRemainingBeforeLockout, 3);
      expect(await passcode.getFailedAttempts(), 1);
    });

    test('5 wrong attempts triggers 30 s lockout', () async {
      for (var i = 0; i < 4; i++) {
        await lock.verifyPasscode('9999');
      }
      // 5th wrong attempt = lockout.
      final result = await lock.verifyPasscode('9999');
      expect(result, isA<UnlockLockedOut>());
      final locked = result as UnlockLockedOut;
      expect(locked.remaining.inSeconds, greaterThan(25));
      expect(locked.remaining.inSeconds, lessThanOrEqualTo(30));
      expect(await passcode.getFailedAttempts(), 5);
    });

    test('10 wrong attempts triggers 5 min lockout', () async {
      // Manually push attempts to 9 by bumping the counter (faster than going
      // through 9 verifyPasscode calls which would each set a 30s window).
      for (var i = 0; i < 9; i++) {
        await passcode.incrementFailedAttempts();
      }
      // Clear stale lockout window so verifyPasscode actually runs.
      await passcode.setLockoutUntil(null);

      final result = await lock.verifyPasscode('9999');
      expect(result, isA<UnlockLockedOut>());
      final locked = result as UnlockLockedOut;
      expect(locked.remaining.inMinutes, greaterThanOrEqualTo(4));
      expect(locked.remaining.inMinutes, lessThanOrEqualTo(5));
      expect(await passcode.getFailedAttempts(), 10);
    });

    test('attempt during active lockout returns UnlockLockedOut without bump',
        () async {
      // Plant a future lockout directly.
      final until = DateTime.now().add(const Duration(seconds: 25));
      await passcode.setLockoutUntil(until);
      final beforeAttempts = await passcode.getFailedAttempts();

      final result = await lock.verifyPasscode('1234');
      expect(result, isA<UnlockLockedOut>());
      expect(await passcode.getFailedAttempts(), beforeAttempts,
          reason: 'in-lockout attempts must NOT bump the counter');
    });

    test('expired lockout window auto-clears and verification proceeds',
        () async {
      // Plant a past lockout — should be cleared on next verifyPasscode.
      await passcode.setLockoutUntil(
          DateTime.now().subtract(const Duration(seconds: 5)));
      final result = await lock.verifyPasscode('1234');
      expect(result, isA<UnlockSuccess>());
      expect(await passcode.getLockoutUntil(), isNull);
    });
  });

  group('persistence across app kill', () {
    test('lockoutUntil survives service re-instantiation (same FSS store)',
        () async {
      // First instance: trigger lockout.
      for (var i = 0; i < 5; i++) {
        await lock.verifyPasscode('9999');
      }
      expect(await passcode.getLockoutUntil(), isNotNull);

      // Simulate "app kill" — drop both service objects, instantiate fresh
      // ones against the same FakeSecureStorage map.
      lock.dispose();
      _disposed = true;
      final freshPasscode = PasscodeServiceImpl(storage: storage);
      final freshLock = AppLockService(
        passcode: freshPasscode,
        biometric: _FakeBiometricManager(),
      );

      // Active lockout should still be visible.
      final active = await freshLock.getActiveLockout();
      expect(active, isNotNull);
      expect(active!.inSeconds, greaterThan(0));
      expect(await freshPasscode.getFailedAttempts(), 5);

      freshLock.dispose();
    });
  });

  group('verifyBiometric', () {
    test('success unlocks and resets counters', () async {
      lock.lockNow();
      // Bump attempts to verify they get cleared.
      await passcode.incrementFailedAttempts();
      await passcode.incrementFailedAttempts();

      final result = await lock.verifyBiometric(reason: 'unlock');
      expect(result, isA<UnlockSuccess>());
      expect(lock.lockedNotifier.value, isFalse);
      expect(await passcode.getFailedAttempts(), 0);
    });

    test('unavailable returns UnlockBiometricUnavailable', () async {
      biometric.available = false;
      final result = await lock.verifyBiometric(reason: 'unlock');
      expect(result, isA<UnlockBiometricUnavailable>());
    });

    test('user-cancel returns UnlockBiometricFailed', () async {
      biometric.authResult = false;
      final result = await lock.verifyBiometric(reason: 'unlock');
      expect(result, isA<UnlockBiometricFailed>());
    });
  });

  group('changePasscode (AUTH-007)', () {
    test('wrong current PIN counts toward lockout', () async {
      final before = await passcode.getFailedAttempts();
      final result = await lock.changePasscode(current: '9999', next: '5555');
      expect(result, isA<UnlockWrong>());
      expect(await passcode.getFailedAttempts(), before + 1);
      // Old hash still verifies.
      expect(await passcode.verify('1234'), isTrue);
    });

    test('correct current PIN swaps hash + resets counters', () async {
      await passcode.incrementFailedAttempts();
      final result = await lock.changePasscode(current: '1234', next: '5555');
      expect(result, isA<UnlockSuccess>());
      expect(await passcode.verify('5555'), isTrue);
      expect(await passcode.verify('1234'), isFalse);
      expect(await passcode.getFailedAttempts(), 0);
    });
  });

  group('auto-lock threshold (G-004)', () {
    test('resume after 30 s flips notifier to true', () async {
      lock.recordPaused(DateTime(2026, 6, 5, 10, 0, 0));
      await lock.evaluateResume(DateTime(2026, 6, 5, 10, 0, 31));
      expect(lock.lockedNotifier.value, isTrue);
    });

    test('resume before 30 s does NOT lock', () async {
      lock.recordPaused(DateTime(2026, 6, 5, 10, 0, 0));
      await lock.evaluateResume(DateTime(2026, 6, 5, 10, 0, 25));
      expect(lock.lockedNotifier.value, isFalse);
    });

    test('threshold injection point honours custom Duration provider',
        () async {
      lock.dispose();
      _disposed = true;
      final custom = AppLockService(
        passcode: passcode,
        biometric: biometric,
        autoLockThreshold: () => const Duration(seconds: 5),
      );
      custom.recordPaused(DateTime(2026, 6, 5, 10, 0, 0));
      await custom.evaluateResume(DateTime(2026, 6, 5, 10, 0, 6));
      expect(custom.lockedNotifier.value, isTrue);
      custom.dispose();
    });

    test('resume when security not enabled does NOT lock', () async {
      await passcode.clear();
      lock.recordPaused(DateTime(2026, 6, 5, 10, 0, 0));
      await lock.evaluateResume(DateTime(2026, 6, 5, 10, 1, 0));
      expect(lock.lockedNotifier.value, isFalse);
    });
  });
}
