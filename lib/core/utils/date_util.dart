// ignore_for_file: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DateUtil {
  static String? convertStringDateTimeToStringDate(String stringDateTime) {
    var dateTime = DateTime.tryParse(stringDateTime);
    if (dateTime != null) return DateFormat('yyyy-MM-dd').format(dateTime);
    else return stringDateTime;
  }
}