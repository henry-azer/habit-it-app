import '../entities/app_entity.dart';
import '../../core/utils/result.dart';

abstract class IAppRepository {
  Stream<AppEntity> watch();
  Future<Result<AppEntity>> get();
  Future<Result<void>> setInit(bool value);
  Future<Result<void>> setInitDate(String value);
  Future<Result<void>> setLastDate(String value);
  Future<Result<void>> setMigratedV1(bool value);
}
