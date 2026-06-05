import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/services/auth/auth_migrator.dart';
import 'package:habit_it/core/services/auth/passcode_service_impl.dart';
import 'package:habit_it/core/utils/result.dart';
import 'package:habit_it/data/entities/user_entity.dart';
import 'package:habit_it/data/repositories/i_user_repository.dart';

import '_fake_secure_storage.dart';

/// In-memory `IUserRepository` double — sufficient for the AuthMigrator tests
/// which only care about `get()`, `update()`, and `clearLegacyPassword()`.
class _FakeUserRepository implements IUserRepository {
  UserEntity _user;
  _FakeUserRepository(this._user);

  @override
  Stream<UserEntity> watch() => const Stream.empty();

  @override
  Future<Result<UserEntity>> get() async => Ok(_user);

  @override
  Future<Result<void>> update(UserEntity user) async {
    _user = user;
    return const Ok(null);
  }

  @override
  Future<Result<void>> setUsernameAndGender(String username, String gender) async {
    _user = _user.copyWith(username: username, gender: gender, isRegistered: true);
    return const Ok(null);
  }

  @override
  Future<Result<void>> setAuthentication(bool value) async {
    _user = _user.copyWith(isAuthenticated: value);
    return const Ok(null);
  }

  @override
  Future<Result<void>> setPINAuthentication(bool value) async {
    _user = _user.copyWith(isPINAuthenticated: value, isAuthenticated: value);
    return const Ok(null);
  }

  @override
  Future<Result<void>> setBiometricAuthentication(bool value) async {
    _user = _user.copyWith(isBiometricAuthenticated: value, isAuthenticated: value);
    return const Ok(null);
  }

  @override
  Future<Result<void>> clearLegacyPassword() async {
    _user = _user.copyWith(password: null);
    return const Ok(null);
  }

  UserEntity get currentUser => _user;
}

/// TS-AUTH-001 AC#5 — legacy 5-digit plain-text PIN migration.
///
/// PO G-003: correct entry routes to `PasscodeUpgradeScreen` (NOT to
/// `PasscodeSetupScreen`), no biometric chain — that's encoded in
/// `MigrationOutcome.verified` and the explicit AC docs.
void main() {
  late FakeSecureStorage storage;
  late PasscodeServiceImpl passcode;
  late _FakeUserRepository userRepo;
  late AuthMigrator migrator;

  setUp(() {
    storage = FakeSecureStorage();
    passcode = PasscodeServiceImpl(storage: storage);
  });

  group('isMigrationPending', () {
    test('true when legacy password present AND no new hash', () async {
      userRepo = _FakeUserRepository(const UserEntity(
        id: 'u1',
        username: 'legacy-user',
        password: '12345',
        isRegistered: true,
      ));
      migrator = AuthMigrator(userRepo, passcode);

      expect(await migrator.isMigrationPending(), isTrue);
    });

    test('false when no legacy password', () async {
      userRepo = _FakeUserRepository(const UserEntity(
        id: 'u1',
        username: 'fresh-user',
        isRegistered: true,
      ));
      migrator = AuthMigrator(userRepo, passcode);

      expect(await migrator.isMigrationPending(), isFalse);
    });

    test('false when new hash already set (already migrated)', () async {
      userRepo = _FakeUserRepository(const UserEntity(
        id: 'u1',
        username: 'migrated-user',
        password: '12345',
        isRegistered: true,
      ));
      migrator = AuthMigrator(userRepo, passcode);
      await passcode.setPasscode('5555');

      expect(await migrator.isMigrationPending(), isFalse);
    });

    test('false when user record absent / empty', () async {
      userRepo = _FakeUserRepository(const UserEntity());
      migrator = AuthMigrator(userRepo, passcode);

      expect(await migrator.isMigrationPending(), isFalse);
    });
  });

  group('verifyLegacyPin', () {
    setUp(() {
      userRepo = _FakeUserRepository(const UserEntity(
        id: 'u1',
        username: 'legacy-user',
        password: '12345',
        isRegistered: true,
      ));
      migrator = AuthMigrator(userRepo, passcode);
    });

    test('correct PIN returns verified — caller will route to upgrade screen '
        '(PO G-003, NOT setup, no biometric chain)', () async {
      final outcome = await migrator.verifyLegacyPin('12345');
      expect(outcome, MigrationOutcome.verified);
      // Legacy password is NOT auto-hashed (PIN-length change 5 -> 4).
      // The caller drives PasscodeUpgradeScreen which calls service.enable(newPin).
      expect(await passcode.isSet(), isFalse,
          reason: 'verifying legacy PIN must NOT persist a new hash');
      // Legacy password is NOT cleared yet — only after the upgrade flow
      // completes does the caller invoke `finalize()`.
      expect(userRepo.currentUser.password, '12345',
          reason: 'legacy password stays until finalize()');
    });

    test('wrong PIN returns wrongPin', () async {
      final outcome = await migrator.verifyLegacyPin('99999');
      expect(outcome, MigrationOutcome.wrongPin);
    });

    test('user with no legacy password returns notNeeded', () async {
      userRepo = _FakeUserRepository(const UserEntity());
      migrator = AuthMigrator(userRepo, passcode);
      final outcome = await migrator.verifyLegacyPin('12345');
      expect(outcome, MigrationOutcome.notNeeded);
    });
  });

  group('finalize', () {
    test('clears legacy password on the user record', () async {
      userRepo = _FakeUserRepository(const UserEntity(
        id: 'u1',
        username: 'legacy-user',
        password: '12345',
        isRegistered: true,
      ));
      migrator = AuthMigrator(userRepo, passcode);

      await migrator.finalize();
      expect(userRepo.currentUser.password, isNull);
    });
  });
}
