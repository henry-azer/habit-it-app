import 'dart:math';

import 'package:habit_it/core/utils/app_strings.dart';

class NumbersUtil {
  static String getRandomCode() {
    Random random = Random();
    String result = '';

    for (int i = 0; i < 5; i++) {
      int randomNumber = random.nextInt(10);
      result += randomNumber.toString();
    }

    return result;
  }

  static String getRandomId() {
    const String character = AppStrings.characters;
    final random = Random();
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += character[random.nextInt(character.length)];
    }
    return code;
  }
}
