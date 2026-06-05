import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/user_entity.dart';
import '../../repositories/i_user_repository.dart';
import '../hive/hive_user_source.dart';

class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl(this._source);
  final HiveUserSource _source;
  final BehaviorSubject<UserEntity> _stream = BehaviorSubject<UserEntity>();
  Future<void> _serial = Future.value();

  @override
  Stream<UserEntity> watch() => _stream;

  @override
  Future<Result<UserEntity>> get() async {
    try {
      final user = await _source.read();
      if (!_stream.isClosed && _stream.valueOrNull != user) _stream.add(user);
      return Ok(user);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  Future<Result<void>> _mutate(UserEntity Function(UserEntity) f) {
    final completer = Completer<Result<void>>();
    _serial = _serial.then((_) async {
      try {
        final current = await _source.read();
        final next = f(current);
        await _source.write(next);
        if (!_stream.isClosed) _stream.add(next);
        completer.complete(const Ok(null));
      } catch (e, st) {
        completer.complete(Err(StorageFailure(e.toString(), st)));
      }
    });
    return completer.future;
  }

  @override
  Future<Result<void>> update(UserEntity user) => _mutate((_) => user);

  @override
  Future<Result<void>> setUsernameAndGender(String username, String gender) =>
      _mutate((u) => u.copyWith(username: username, gender: gender, isRegistered: true));

  @override
  Future<Result<void>> setAuthentication(bool value) =>
      _mutate((u) => u.copyWith(isAuthenticated: value));

  @override
  Future<Result<void>> setPINAuthentication(bool value) =>
      _mutate((u) => u.copyWith(isPINAuthenticated: value, isAuthenticated: value));

  @override
  Future<Result<void>> setBiometricAuthentication(bool value) =>
      _mutate((u) => u.copyWith(isBiometricAuthenticated: value, isAuthenticated: value));

  @override
  Future<Result<void>> clearLegacyPassword() =>
      _mutate((u) => u.copyWith(password: null));
}
