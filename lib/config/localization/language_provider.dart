import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/data/entities/language_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

  bool _isLoading = false;
  Locale _currentLocale = const Locale('en');
  List<LanguageOption> _availableLanguages = [
    LanguageOption(code: 'en', name: 'English', nativeName: 'English', textDirection: 'ltr'),
  ];

  LanguageProvider() {
    _initialize();
  }

  bool get isLoading => _isLoading;
  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  List<LanguageOption> get availableLanguages => _availableLanguages;
  TextDirection get textDirection => AppLocalization.textDirection;
  bool get isRTL => AppLocalization.isRTL;

  List<Locale> get availableLanguagesLocales {
    if (_availableLanguages.isEmpty) {
      return [const Locale('en')];
    }
    return _availableLanguages.map((lang) => Locale(lang.code)).toList();
  }

  String get currentLanguageName {
    final currentLang = _availableLanguages.firstWhere(
      (lang) => lang.code == _currentLocale.languageCode,
      orElse: () =>
          LanguageOption(code: 'en', name: 'English', nativeName: 'English', textDirection: 'ltr'),
    );
    return currentLang.name;
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final languages = await AppLocalization.getAvailableLanguages();
      if (languages.isNotEmpty) {
        _availableLanguages = languages;
      }
      await _loadSavedLanguage();
      await AppLocalization.initialize(language: _currentLocale.languageCode);
    } catch (e) {
      debugPrint('Error initializing language provider: $e');
      if (_availableLanguages.isEmpty) {
        _availableLanguages = [
          LanguageOption(code: 'en', name: 'English', nativeName: 'English', textDirection: 'ltr'),
        ];
      }
      _currentLocale = const Locale('en');
      await AppLocalization.initialize(language: 'en');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(AppLocalStorageKeys.selectedLanguage);

      if (savedLanguage != null) {
        final isValid = _availableLanguages.any((lang) => lang.code == savedLanguage);
        if (isValid) {
          _currentLocale = Locale(savedLanguage);
        } else {
          _currentLocale = const Locale('en');
          await _clearSavedLanguage();
        }
      } else {
        _currentLocale = const Locale('en');
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
      _currentLocale = const Locale('en');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    try {
      final isValid = _availableLanguages.any((lang) => lang.code == languageCode);
      if (!isValid) {
        debugPrint('Invalid language code: $languageCode');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppLocalStorageKeys.selectedLanguage, languageCode);
      _currentLocale = Locale(languageCode);
      await AppLocalization.changeLanguage(languageCode);

      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  Future<void> _clearSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppLocalStorageKeys.selectedLanguage);
    } catch (e) {
      debugPrint('Error clearing saved language: $e');
    }
  }

  LanguageOption? getLanguageByCode(String code) {
    try {
      return _availableLanguages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      debugPrint('Error getting language by code: $e');
      return null;
    }
  }

  Future<void> refreshLanguages() async {
    try {
      _availableLanguages = await AppLocalization.getAvailableLanguages();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing languages: $e');
    }
  }
}
