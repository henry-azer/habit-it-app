import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../core/usecases/usecase.dart';

abstract class AuthenticationRepository {
  Future<Either<GenericException, NoParams>> registerUserPIN(String pin);
}
