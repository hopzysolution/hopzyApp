import 'package:ridebooking/models/station_model.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}
class HomeScreenLoading extends HomeScreenState {}
class HomeScreenLoaded extends HomeScreenState {
  final StationModel? stations;

  HomeScreenLoaded({this.stations});
}
class HomeScreenFailure extends HomeScreenState {
  final String error;

  HomeScreenFailure({required this.error});
}