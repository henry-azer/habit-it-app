enum Gender {
  male,
  female,
}

final List<String> genders = [
  'Male',
  'Female',
];

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