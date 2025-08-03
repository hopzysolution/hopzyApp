import 'package:intl/intl.dart';

class Utils {
  static futureDate() {
    return DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().add(Duration(days: 1)));
  }

  static todaysDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
