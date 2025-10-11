import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';

abstract class BookingListEvent {}

class FetchBookingsEvent extends BookingListEvent {}

class FetchCancelDetailsEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;
  final String ticketId;
  final Booking booking; // Add complete booking object

  FetchCancelDetailsEvent(this.pnr, this.seatNo, this.ticketId, this.booking);
}

class CancelBookingEvent extends BookingListEvent {
  final String pnr;
  final String seatNo;

  CancelBookingEvent(this.pnr, this.seatNo);
}
