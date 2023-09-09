import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';

abstract class LocalizationRepository {
  Future<Either<GenericException, String>> getSavedLang();
  Future<Either<GenericException, bool>> changeLang({required String langCode});
}
