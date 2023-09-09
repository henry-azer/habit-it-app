import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../datasources/localization/localization_local_data_source.dart';
import 'localization_repository.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationLocalDataSource localizationLocalDataSource;

  LocalizationRepositoryImpl({required this.localizationLocalDataSource});

  @override
  Future<Either<GenericException, String>> getSavedLang() async {
    try {
      final langCode = await localizationLocalDataSource.getSavedLang();
      return Right(langCode);
    } on CacheException {
      return const Left(CacheException());
    }
  }

  @override
  Future<Either<GenericException, bool>> changeLang(
      {required String langCode}) async {
    try {
      final langIsChanged =
      await localizationLocalDataSource.changeLang(langCode: langCode);
      return Right(langIsChanged);
    } on CacheException {
      return const Left(CacheException());
    }
  }
}
