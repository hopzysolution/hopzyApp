
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/station_model.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}
class HomeScreenLoading extends HomeScreenState {}
class HomeScreenLoaded extends HomeScreenState {
  final List<StationDetails>? stations;

  HomeScreenLoaded({this.stations});
}
class HomeScreenFailure extends HomeScreenState {
  final String error;

  HomeScreenFailure({required this.error});
}

class AllTripSuccessState extends HomeScreenState {

final List<Availabletrips>? allTrips;

  AllTripSuccessState({this.allTrips});
}