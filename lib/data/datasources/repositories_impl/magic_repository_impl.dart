import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../repositories/i_magic_repository.dart';
import '../hive/hive_magic_meta_source.dart';

class MagicRepositoryImpl implements IMagicRepository {
  MagicRepositoryImpl(this._source);
  final HiveMagicMetaSource _source;

  @override
  Future<Result<List<DateTime>>> getQuotaLog() async {
    try {
      return Ok(await _source.readQuotaLog());
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> appendQuotaLog(DateTime at) async {
    try {
      final log = List<DateTime>.from(await _source.readQuotaLog())..add(at);
      await _source.writeQuotaLog(log);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> pruneOlderThan(DateTime cutoff) async {
    try {
      final log = (await _source.readQuotaLog())
          .where((d) => d.isAfter(cutoff))
          .toList();
      await _source.writeQuotaLog(log);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<bool>> isCoachPrivacyAcknowledged() async {
    try {
      return Ok(await _source.readCoachPrivacyAck());
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> markCoachPrivacyAcknowledged() async {
    try {
      await _source.writeCoachPrivacyAck(true);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }
}
