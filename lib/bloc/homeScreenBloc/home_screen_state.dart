
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/operator_list_model.dart';
// import 'package:ridebooking/models/station_model.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}
class HomeScreenLoading extends HomeScreenState {}
class HomeScreenLoaded extends HomeScreenState {
  final List<City>? stationListModel;

  HomeScreenLoaded({this.stationListModel});
}
class HomeScreenFailure extends HomeScreenState {
  final String error;

  HomeScreenFailure({required this.error});
}

class AllTripSuccessState extends HomeScreenState {

final List<Trips>? allTrips;

  AllTripSuccessState({this.allTrips});
}