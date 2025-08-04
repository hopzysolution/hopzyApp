import 'package:intl/intl.dart';

String selectedDate = DateFormat(
  'yyyy-MM-dd',
).format(DateTime.now().add(Duration(days: 1)));

String dateForTicket=DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now());
