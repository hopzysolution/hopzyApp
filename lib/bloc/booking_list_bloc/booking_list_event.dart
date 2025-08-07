abstract class BookingListEvent {}

class FetchBookingsEvent extends BookingListEvent {}

class FetchCancelDetailsEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;

  FetchCancelDetailsEvent(this.pnr, this.seatNo);
}

class CancelBookingEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;

  CancelBookingEvent(this.pnr, this.seatNo);
}