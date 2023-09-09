import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/models/response_model.dart';
import '../../../core/network/network_info.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/app_strings.dart';
import '../../datasources/authentication/authentication_local_datasource.dart';
import '../../entities/authentication/signin.dart';
import '../../datasources/authentication/authentication_remote_datasource.dart';
import '../../entities/authentication/signin_claims.dart';
import '../../entities/user/user.dart';
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
  Future<Either<GenericException, ResponseModel<User>>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final responseCurrentUser = await authenticationRemoteDataSource.findCurrentUser();
        await authenticationLocalDataSource.cacheCurrentUser(responseCurrentUser.body);
        return Right(responseCurrentUser);
      } on GenericException catch (exception) {
        return Left(exception);
      }
    } else {
      try {
        final cachedCurrentUser = await authenticationLocalDataSource.getCurrentUser();
        return Right(ResponseModel(success: true, message: AppStrings.cachedUserFetchSuccess, body: cachedCurrentUser));
      } on CacheException {
        return const Left(CacheException());
      }
    }
  }

  @override
  Future<Either<GenericException, ResponseModel<SigninClaims>>> signin(Signin signin) async {
    if (await networkInfo.isConnected) {
      try {
        await authenticationLocalDataSource.clearCache();
        await authenticationLocalDataSource.cacheIsUserLogging();
        final responseSigninClaims = await authenticationRemoteDataSource.signin(signin);
        await authenticationLocalDataSource.cacheSigninClaims(signin, responseSigninClaims.body);
        return Right(responseSigninClaims);
      } on GenericException catch (exception) {
        return Left(exception);
      }
    } else {
      return const Left(CacheException());
    }
  }

  @override
  Future<Either<GenericException, ResponseModel<NoParams>>> signout() async {
    if (await networkInfo.isConnected) {
      try {
        final signoutResponse = await authenticationRemoteDataSource.signout();
        await authenticationLocalDataSource.clearCache();
        return Right(signoutResponse);
      } on GenericException catch (exception) {
        return Left(exception);
      }
    } else {
      return const Left(CacheException());
    }
  }
}
