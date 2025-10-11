import 'package:ridebooking/models/operator_list_model.dart';

abstract class HomeScreenEvent {}

class SearchAvailableTripsEvent extends HomeScreenEvent {
  final City src;
  final City dst;
  final String date;

  SearchAvailableTripsEvent({required this.src, required this.dst, required this.date});
}