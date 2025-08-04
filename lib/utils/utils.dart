import 'dart:ui';

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


 static Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // add opacity if not provided
  }
  return Color(int.parse(hex, radix: 16));
}
}
