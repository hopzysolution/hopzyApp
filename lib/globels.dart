import 'package:intl/intl.dart';
import 'package:ridebooking/models/operator_list_model.dart';

String selectedDate = DateFormat(
  'yyyy-MM-dd',
).format(DateTime.now());

 final now = DateTime.now().toUtc(); // same as JS new Date().toISOString()
 
String dateForTicket=now.toIso8601String().replaceAll(RegExp(r'[-:.TZ]'), '');

String phoneNo= "8305933803";
String email="aadityagupta778@gmail.com";

StationListModel stationListModel = StationListModel();
