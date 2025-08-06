abstract class BookingListEvent {}

class FetchBookingsEvent extends BookingListEvent {}

class CancelBookingEvent extends BookingListEvent {
  final String bookingId;

  CancelBookingEvent(this.bookingId);
}