import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/managers/biometric/i_biometric_manager.dart';
import 'package:habit_it/core/services/auth/app_lock_service.dart';
import 'package:habit_it/core/services/auth/passcode_service_impl.dart';
import 'package:habit_it/core/services/auth/unlock_result.dart';
import 'package:habit_it/features/auth/viewmodels/passcode_signin_viewmodel.dart';

import '../../../core/services/auth/_fake_secure_storage.dart';

class _FakeBiometric implements IBiometricManager {
  bool available;
  bool authResult;
  _FakeBiometric({this.available = true, this.authResult = true});
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<bool> authenticate({required String reason, bool stickyAuth = true}) async => authResult;
}

void main() {
  late FakeSecureStorage storage;
  late PasscodeServiceImpl passcode;
  late _FakeBiometric biometric;
  late AppLockService lock;
  late PasscodeSigninViewModel vm;

  setUp(() async {
    storage = FakeSecureStorage();
    passcode = PasscodeServiceImpl(storage: storage);
    biometric = _FakeBiometric();
    lock = AppLockService(passcode: passcode, biometric: biometric);
    await passcode.setPasscode('1234');
    vm = PasscodeSigninViewModel(appLock: lock);
  });

  tearDown(() {
    vm.dispose();
    lock.dispose();
  });

  test('correct PIN emits UnlockSuccess', () async {
    lock.lockNow();
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    await vm.onDigit('4');
    expect(vm.result$.value, isA<UnlockSuccess>());
    expect(vm.processing$.value, isFalse);
  });

  test('wrong PIN emits UnlockWrong AND increments attempts', () async {
    vm.onDigit('9');
    vm.onDigit('9');
    vm.onDigit('9');
    await vm.onDigit('9');
    expect(vm.result$.value, isA<UnlockWrong>());
    expect(await passcode.getFailedAttempts(), 1);
    // Buffer cleared so the next attempt starts fresh.
    expect(vm.buffer$.value, '');
  });

  test('5 wrong PINs trigger UnlockLockedOut on the 5th', () async {
    for (var i = 0; i < 4; i++) {
      vm.onDigit('9');
      vm.onDigit('9');
      vm.onDigit('9');
      await vm.onDigit('9');
    }
    expect(vm.result$.value, isA<UnlockWrong>());
    vm.onDigit('9');
    vm.onDigit('9');
    vm.onDigit('9');
    await vm.onDigit('9');
    expect(vm.result$.value, isA<UnlockLockedOut>());
  });

  test('biometric trigger forwards to AppLockService.verifyBiometric',
      () async {
    await vm.tryBiometric('unlock');
    expect(vm.result$.value, isA<UnlockSuccess>());
  });

  test('biometric unavailable returns UnlockBiometricUnavailable', () async {
    biometric.available = false;
    await vm.tryBiometric('unlock');
    expect(vm.result$.value, isA<UnlockBiometricUnavailable>());
  });

  test('backspace removes a digit', () {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onBackspace();
    expect(vm.buffer$.value, '1');
  });
}
