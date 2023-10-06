import 'dart:math';

class NumbersUtil {
  static List<int> getRandomCode() {
    Random random = Random();
    List<int> randomNumbers = [];

    for (int i = 0; i < 5; i++) {
      randomNumbers.add(random.nextInt(100));
    }

    return randomNumbers;
  }
}
