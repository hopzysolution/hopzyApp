abstract class BookingState {}



class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState {
  // final List<StationDetails>? stations;
int? fare;
  BookingLoaded({this.fare});
}
class BookingFailure extends BookingState {
  final String error;

  BookingFailure({required this.error});
}

class BookingSuccess extends BookingState {
  final String success;

  BookingSuccess({required this.success});
}

// class AllTripSuccessState extends BookingState {

// final List<Availabletrips>? allTrips;

//   AllTripSuccessState({this.allTrips});
// }