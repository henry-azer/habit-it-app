import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/managers/biometric/i_biometric_manager.dart';
import 'package:habit_it/core/services/auth/app_lock_service.dart';
import 'package:habit_it/core/services/auth/passcode_service_impl.dart';
import 'package:habit_it/core/utils/result.dart';
import 'package:habit_it/data/entities/user_entity.dart';
import 'package:habit_it/data/repositories/i_user_repository.dart';
import 'package:habit_it/features/auth/viewmodels/passcode_setup_viewmodel.dart';

import '../../../core/services/auth/_fake_secure_storage.dart';

class _FakeBiometric implements IBiometricManager {
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<bool> authenticate({required String reason, bool stickyAuth = true}) async => false;
}

class _FakeUserRepo implements IUserRepository {
  UserEntity user = const UserEntity();
  bool pinAuthSet = false;

  @override
  Stream<UserEntity> watch() => const Stream.empty();
  @override
  Future<Result<UserEntity>> get() async => Ok(user);
  @override
  Future<Result<void>> update(UserEntity u) async {
    user = u;
    return const Ok(null);
  }
  @override
  Future<Result<void>> setUsernameAndGender(String username, String gender) async {
    user = user.copyWith(username: username, gender: gender, isRegistered: true);
    return const Ok(null);
  }
  @override
  Future<Result<void>> setAuthentication(bool value) async {
    user = user.copyWith(isAuthenticated: value);
    return const Ok(null);
  }
  @override
  Future<Result<void>> setPINAuthentication(bool value) async {
    pinAuthSet = value;
    user = user.copyWith(isPINAuthenticated: value, isAuthenticated: value);
    return const Ok(null);
  }
  @override
  Future<Result<void>> setBiometricAuthentication(bool value) async {
    user = user.copyWith(isBiometricAuthenticated: value, isAuthenticated: value);
    return const Ok(null);
  }
  @override
  Future<Result<void>> clearLegacyPassword() async {
    user = user.copyWith(password: null);
    return const Ok(null);
  }
}

void main() {
  late FakeSecureStorage storage;
  late PasscodeServiceImpl passcode;
  late AppLockService lock;
  late _FakeUserRepo userRepo;
  late PasscodeSetupViewModel vm;

  setUp(() {
    storage = FakeSecureStorage();
    passcode = PasscodeServiceImpl(storage: storage);
    lock = AppLockService(passcode: passcode, biometric: _FakeBiometric());
    userRepo = _FakeUserRepo();
    vm = PasscodeSetupViewModel(appLock: lock, userRepo: userRepo);
  });

  tearDown(() {
    vm.dispose();
    lock.dispose();
  });

  test('starts in create step with empty buffer', () {
    expect(vm.step$.value, PasscodeSetupStep.create);
    expect(vm.buffer$.value, '');
    expect(vm.error$.value, isNull);
  });

  test('onDigit fills buffer, auto-advances to confirm at 4 digits', () async {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    expect(vm.step$.value, PasscodeSetupStep.create);
    vm.onDigit('4');
    // advance is async — give it a microtask.
    await Future<void>.delayed(Duration.zero);
    expect(vm.step$.value, PasscodeSetupStep.confirm);
    expect(vm.buffer$.value, '');
  });

  test('onBackspace removes one digit from buffer', () {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onBackspace();
    expect(vm.buffer$.value, '1');
  });

  test('confirm matching the create PIN persists hash + sets PIN flag',
      () async {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    vm.onDigit('4');
    await Future<void>.delayed(Duration.zero);
    // Now in confirm.
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    vm.onDigit('4');
    await Future<void>.delayed(Duration.zero);

    expect(vm.completed$.value, isTrue);
    expect(await passcode.isSet(), isTrue);
    expect(await passcode.verify('1234'), isTrue);
    expect(userRepo.pinAuthSet, isTrue);
  });

  test('mismatch on confirm resets to create + emits error', () async {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    vm.onDigit('4');
    await Future<void>.delayed(Duration.zero);
    // Now in confirm — enter different digits.
    vm.onDigit('5');
    vm.onDigit('6');
    vm.onDigit('7');
    vm.onDigit('8');
    await Future<void>.delayed(Duration.zero);

    expect(vm.step$.value, PasscodeSetupStep.create);
    expect(vm.buffer$.value, '');
    expect(vm.error$.value, 'mismatch');
    expect(vm.completed$.value, isFalse);
    expect(await passcode.isSet(), isFalse);
  });

  test('resetToCreate from confirm clears state', () async {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    vm.onDigit('4');
    await Future<void>.delayed(Duration.zero);
    expect(vm.step$.value, PasscodeSetupStep.confirm);
    vm.resetToCreate();
    expect(vm.step$.value, PasscodeSetupStep.create);
    expect(vm.buffer$.value, '');
  });

  test('starting fresh entry after error clears the error message', () {
    vm.error$.add('mismatch');
    vm.onDigit('1');
    expect(vm.error$.value, isNull);
  });

  test('4th digit triggers auto-advance (no overflow)', () async {
    vm.onDigit('1');
    vm.onDigit('2');
    vm.onDigit('3');
    expect(vm.buffer$.value, '123');
    vm.onDigit('4');
    await Future<void>.delayed(Duration.zero);
    expect(vm.buffer$.value, '');
    expect(vm.step$.value, PasscodeSetupStep.confirm);
  });
}
