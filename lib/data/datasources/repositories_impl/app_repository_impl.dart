import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../entities/app_entity.dart';
import '../../repositories/i_app_repository.dart';
import '../hive/hive_app_source.dart';

class AppRepositoryImpl implements IAppRepository {
  AppRepositoryImpl(this._source);
  final HiveAppSource _source;
  final BehaviorSubject<AppEntity> _stream = BehaviorSubject<AppEntity>();
  Future<void> _serial = Future.value();

  @override
  Stream<AppEntity> watch() => _stream;

  @override
  Future<Result<AppEntity>> get() async {
    try {
      final entity = await _source.read();
      if (!_stream.isClosed && _stream.valueOrNull != entity) {
        _stream.add(entity);
      }
      return Ok(entity);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  Future<Result<void>> _mutate(AppEntity Function(AppEntity) f) {
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
  Future<Result<void>> setInit(bool value) =>
      _mutate((s) => s.copyWith(init: value));

  @override
  Future<Result<void>> setInitDate(String value) =>
      _mutate((s) => s.copyWith(initDate: value));

  @override
  Future<Result<void>> setLastDate(String value) =>
      _mutate((s) => s.copyWith(lastDate: value));

  @override
  Future<Result<void>> setMigratedV1(bool value) =>
      _mutate((s) => s.copyWith(migratedV1: value));
}
