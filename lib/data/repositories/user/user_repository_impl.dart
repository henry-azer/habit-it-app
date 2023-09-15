import 'package:dartz/dartz.dart';
import 'package:habit_it/data/repositories/user/user_repository.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/usecases/usecase.dart';
import '../../datasources/user/user_local_datasource.dart';
import '../../datasources/user/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl(
      {required this.networkInfo,
      required this.userLocalDataSource,
      required this.userRemoteDataSource});

  @override
  Future<Either<GenericException, NoParams>> setAppGetStarted() async {
    try {
      await userLocalDataSource.cacheIsApGetStarted();
      return Right(NoParams());
    } on GenericException catch (exception) {
      return Left(CacheException(exception));
    }
  }
}
