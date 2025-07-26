abstract class AvailableTripsState {}
class AvailableTripsInitial extends AvailableTripsState {}
class AvailableTripsLoading extends AvailableTripsState {}
class AvailableTripsLoaded extends AvailableTripsState {
  // final List<Availabletrips>? availableTrips;

  // AvailableTripsLoaded({this.availableTrips});
}
class AvailableTripsFailure extends AvailableTripsState {
  final String error;

  AvailableTripsFailure({required this.error});
}