import 'package:flutter_starter/core/validation/validation_types.dart';

class ValidateTextFiled {
  final String value;
  final String label;

  ValidateTextFiled({required this.value, required this.label});

  static String? validate(String? value, label) {
    switch (label) {
      case (ValidationTypes.signinEmail):
        {
          return _validateEmail(value!);
        }
      case (ValidationTypes.signinPassword):
        {
          return _validateSigninPassword(value!);
        }
      case (ValidationTypes.signupFirstName):
        {
          return _validateSignupFirstName(value!);
        }
      case (ValidationTypes.signupLastName):
        {
          return _validateSignupLastName(value!);
        }
      case (ValidationTypes.signupPhoneNumber):
        {
          return _validateSignupPhoneNumber(value!);
        }
      case (ValidationTypes.signupBirthDay):
        {
          return _validateSignupDayBirthday(value!);
        }
      case (ValidationTypes.signupBirthMonth):
        {
          return _validateSignupMonthBirthday(value!);
        }
      case (ValidationTypes.signupBirthYear):
        {
          return _validateSignupYearBirthday(value!);
        }
      default:
        return null;
    }
  }
}

String? _validateEmail(String value) {
  if (value.isEmpty) {
    return "required";
  } else if (!_isValidEmail(value)) {
    return "invalid_email";
  } else {
    return "";
  }
}

String? _validateSigninPassword(String value) {
  if (value.isEmpty) {
    return "required";
  } else if (value.length < 8) {
    return "at_least_8_chars";
  } else {
    return "";
  }
}

String? _validateSignupFirstName(String value) {
  if (value.isEmpty) {
    return "required";
  } else if (value.length < 2) {
    return "at_least_3_chars";
  } else {
    return "";
  }
}

String? _validateSignupLastName(String value) {
  if (value.isEmpty) {
    return "required";
  } else if (value.length < 2) {
    return "at_least_3_chars";
  } else {
    return "";
  }
}

String? _validateSignupPhoneNumber(String value) {
  if (value.isEmpty) {
    return "required";
  } else if (value.isEmpty || !_isValidPhoneNumber(value)) {
    return "invalid_phone_number";
  } else {
    return "";
  }
}

String? _validateSignupDayBirthday(String value) {
  if (value.isEmpty) {
    return "invalid_birth_day";
  } else if (_isValidNumber(value)) {
    int? day = int.tryParse(value) ?? 0;
    if (day > 31 || day < 1 || value.length != 2) {
      return "invalid_birth_day";
    } else {
      return "";
    }
  } else {
    return "invalid_birth_day";
  }
}

String? _validateSignupMonthBirthday(String value) {
  if (value.isEmpty) {
    return "invalid_birth_month";
  } else if (_isValidNumber(value)) {
    int? month = int.tryParse(value) ?? 0;
    if (month > 12 || month < 1 || value.length != 2) {
      return "invalid_birth_month";
    } else {
      return "";
    }
  } else {
    return "invalid_birth_month";
  }
}

String? _validateSignupYearBirthday(String value) {
  var date = DateTime.now();
  var minYear = DateTime(date.year - 5).year;
  var maxYear = 1950;
  if (value.isEmpty) {
    return "invalid_birth_year";
  } else if (_isValidNumber(value)) {
    int? year = int.tryParse(value) ?? 0;
    if (year > minYear || year < maxYear || value.length != 4) {
      return "invalid_birth_year";
    } else {
      return "";
    }
  } else {
    return "invalid_birth_year";
  }
}

bool _isValidEmail(String value) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
}

bool _isValidPhoneNumber(String value) {
  return RegExp(r"^01[0125][0-9]{8}$").hasMatch(value);
}

bool _isValidNumber(String value) {
  return RegExp(r"^[0-9]*$").hasMatch(value);
}
