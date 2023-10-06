import 'dart:math';

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
}
