import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_strings.dart';

abstract class LocalizationLocalDataSource {
  Future<bool> changeLang({required String langCode});
  Future<String> getSavedLang();
}

class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalizationLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<bool> changeLang({required String langCode}) async =>
      await sharedPreferences.setString(AppStrings.locale, langCode);

  @override
  Future<String> getSavedLang() async => sharedPreferences.containsKey(AppStrings.locale)
          ? sharedPreferences.getString(AppStrings.locale)! : AppStrings.englishCode;
}
