import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/usecases/usecase.dart';
import '../../datasources/authentication/authentication_local_datasource.dart';
import '../../datasources/authentication/authentication_remote_datasource.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationLocalDataSource authenticationLocalDataSource;
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthenticationRepositoryImpl(
      {required this.networkInfo,
      required this.authenticationLocalDataSource,
      required this.authenticationRemoteDataSource});

  @override
  Future<Either<GenericException, NoParams>> registerUserPIN(String pin) async {
    try {
      await authenticationLocalDataSource.registerUserPIN(pin);
      return Right(NoParams());
    } on CacheException {
      return const Left(CacheException());
    }
  }
}
