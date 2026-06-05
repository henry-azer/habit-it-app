import '../../core/utils/result.dart';

/// Magic-meta (AI coach) repository — quota log + privacy ack.
abstract class IMagicRepository {
  Future<Result<List<DateTime>>> getQuotaLog();
  Future<Result<void>> appendQuotaLog(DateTime at);
  Future<Result<void>> pruneOlderThan(DateTime cutoff);

  Future<Result<bool>> isCoachPrivacyAcknowledged();
  Future<Result<void>> markCoachPrivacyAcknowledged();
}
