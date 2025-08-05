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


class RazorpaySuccessState extends BookingState{
  String? razorpay_order_id;
  RazorpaySuccessState({this.razorpay_order_id});
}

class ConfirmBooking extends BookingState{
  
}


// class AllTripSuccessState extends BookingState {

// final List<Availabletrips>? allTrips;

//   AllTripSuccessState({this.allTrips});
// }