import 'package:dartz/dartz.dart';
import 'package:flutter_starter/data/repositories/user/user_repository.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/models/response_model.dart';
import '../../../core/network/network_info.dart';
import '../../datasources/user/user_local_datasource.dart';
import '../../datasources/user/user_remote_datasource.dart';
import '../../entities/user/signup.dart';
import '../../entities/user/user.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl(
      {required this.networkInfo,
      required this.userLocalDataSource,
      required this.userRemoteDataSource});

  @override
  Future<Either<GenericException, ResponseModel<User>>> signup(Signup signup) async {
    if (await networkInfo.isConnected) {
      try {
        final responseCurrentUser = await userRemoteDataSource.signup(signup);
        return Right(responseCurrentUser);
      } on GenericException catch (exception) {
        return Left(exception);
      }
    } else {
      return const Left(CacheException());
    }
  }
}
