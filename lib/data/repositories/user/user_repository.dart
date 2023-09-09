import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/models/response_model.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user/signup.dart';
import '../../entities/user/user.dart';

abstract class UserRepository {
  Future<Either<GenericException, ResponseModel<User>>> signup(Signup signup);
  Future<Either<GenericException, NoParams>> setAppGetStarted();
}
