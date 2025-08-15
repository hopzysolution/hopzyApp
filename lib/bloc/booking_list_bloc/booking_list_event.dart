abstract class BookingListEvent {}

class FetchBookingsEvent extends BookingListEvent {}

class FetchCancelDetailsEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;
  final String ticketId;

  FetchCancelDetailsEvent(this.pnr, this.seatNo,this.ticketId);
}

class CancelBookingEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;

  CancelBookingEvent(this.pnr, this.seatNo);
}