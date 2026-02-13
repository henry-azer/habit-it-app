import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';


class FormValidators {
  FormValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationEmailRequired.tr;
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.validationEmailInvalid.tr;
    }
    
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationPasswordRequired.tr;
    }
    
    if (value.length < minLength) {
      return AppStrings.validationPasswordMinLength.tr;
    }
    
    return null;
  }

  static String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationCurrentPasswordRequired.tr;
    }
    
    return null;
  }

  static String? validateNewPassword(String? value, String? currentPassword, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationNewPasswordRequired.tr;
    }
    
    if (value.length < minLength) {
      return AppStrings.validationNewPasswordMinLength.tr;
    }
    
    if (currentPassword != null && value == currentPassword) {
      return AppStrings.validationSamePassword.tr;
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return AppStrings.validationConfirmPasswordRequired.tr;
    }
    
    if (value != newPassword) {
      return AppStrings.validationNewPasswordsNotMatch.tr;
    }
    
    return null;
  }

  static String? validateFullName(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationFullNameRequired.tr;
    }
    
    if (value.trim().length < minLength) {
      return AppStrings.validationFullNameMinLength.tr;
    }
    
    return null;
  }

  static String? validatePhoneNumber(String? value, {bool required = true, int minDigits = 11}) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return AppStrings.validationPhoneRequired.tr;
      }
      return null;
    }
    
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.length < minDigits) {
      return AppStrings.validationPhoneMinDigits.tr;
    }
    
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
      return AppStrings.validationPhoneInvalidChars.tr;
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }

  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
