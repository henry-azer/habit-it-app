import 'package:dartz/dartz.dart';
import 'package:habit_it/data/repositories/authentication/authentication_repository.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/usecases/usecase.dart';

class UserPINRegistrationUseCase implements UseCase<NoParams, String> {
  final AuthenticationRepository authenticationRepository;

  UserPINRegistrationUseCase({required this.authenticationRepository});

  @override
  Future<Either<GenericException, NoParams>> call(String pin) async =>
      await authenticationRepository.registerUserPIN(pin);
}
