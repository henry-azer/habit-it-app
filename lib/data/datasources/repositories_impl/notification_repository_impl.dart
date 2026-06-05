import '../../../core/utils/failure.dart';
import '../../../core/utils/result.dart';
import '../../repositories/i_notification_repository.dart';
import '../hive/hive_notification_meta_source.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  NotificationRepositoryImpl(this._source);
  final HiveNotificationMetaSource _source;

  @override
  Future<Result<NotificationMeta?>> getByHabitId(String habitId) async {
    try {
      return Ok(await _source.read(habitId));
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> upsert(NotificationMeta meta) async {
    try {
      await _source.write(meta);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }

  @override
  Future<Result<void>> deleteByHabitId(String habitId) async {
    try {
      await _source.delete(habitId);
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageFailure(e.toString(), st));
    }
  }
}
