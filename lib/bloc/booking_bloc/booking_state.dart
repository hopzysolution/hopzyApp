abstract class BookingState {}



class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState {
  // final List<StationDetails>? stations;

  // BookingLoaded({this.stations});
}
class BookingFailure extends BookingState {
  final String error;

  BookingFailure({required this.error});
}

// class AllTripSuccessState extends BookingState {

// final List<Availabletrips>? allTrips;

//   AllTripSuccessState({this.allTrips});
// }