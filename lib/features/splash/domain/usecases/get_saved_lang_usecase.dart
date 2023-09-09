import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/repositories/localization/localization_repository.dart';

class GetSavedLangUseCase implements UseCase<String, NoParams> {
  final LocalizationRepository langRepository;

  GetSavedLangUseCase({required this.langRepository});

  @override
  Future<Either<GenericException, String>> call(NoParams params) async => await langRepository.getSavedLang();
}
