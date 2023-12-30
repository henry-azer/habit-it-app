enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get value {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      default:
        return "";
    }
  }
}