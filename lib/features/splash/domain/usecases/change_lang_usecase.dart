import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/repositories/localization/localization_repository.dart';

class ChangeLangUseCase implements UseCase<bool, String> {
  final LocalizationRepository langRepository;

  ChangeLangUseCase({required this.langRepository});

  @override
  Future<Either<GenericException, bool>> call(String langCode) async =>
      await langRepository.changeLang(langCode: langCode);
}
