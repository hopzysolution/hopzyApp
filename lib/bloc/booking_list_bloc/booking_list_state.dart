import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';

abstract class BookingListState {}

class BookingListInitial extends BookingListState {}

class BookingListLoading extends BookingListState {}

class BookingListLoaded extends BookingListState {
  final List<Booking> bookings;

  BookingListLoaded({required this.bookings});
}

class BookingListFailure extends BookingListState {
  final String error;

  BookingListFailure({required this.error});
}

class BookingCancelledSuccess extends BookingListState {
  final String message;

  BookingCancelledSuccess({required this.message});
}