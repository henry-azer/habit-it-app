import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/repositories/user/user_repository.dart';

class AppGetStartedUseCase implements UseCase<NoParams, NoParams> {
  final UserRepository userRepository;

  AppGetStartedUseCase({required this.userRepository});

  @override
  Future<Either<GenericException, NoParams>> call(NoParams noParams) async => await userRepository.setAppGetStarted();
}