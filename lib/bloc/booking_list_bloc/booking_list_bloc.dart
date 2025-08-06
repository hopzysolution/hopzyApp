import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';

class BookingListBloc extends Bloc<BookingListEvent, BookingListState> {
  BookingListBloc() : super(BookingListInitial()) {
    on<FetchBookingsEvent>((event, emit) async {
      emit(BookingListLoading());
      try {
        var response = await ApiRepository.getAPI(
          ApiConst.getUserBookings,
          // formData,
          // basurl2: ApiConst.baseUrl2
        );
        final data = response.data;
        print("------------------get user booking------data)-${data}-");

        if (data["status"] != null && data["status"]["success"] == true) {
          final bookings = (data["bookings"] as List)
              .map((json) => Booking.fromJson(json))
              .toList();
          emit(BookingListLoaded(bookings: bookings));
        } else {
          final message =
              data["status"]?["message"] ?? "Failed to load bookings";
          emit(BookingListFailure(error: message));
        }
      } catch (e) {
        emit(
          BookingListFailure(error: "Something went wrong. Please try again."),
        );
      }
    });

    on<CancelBookingEvent>((event, emit) async {
      //   emit(BookingListLoading());
      //   try {
      //     var formData = {
      //       "bookingId": event.bookingId,
      //       "opid": "VGT",
      //     };

      //     var response = await ApiRepository.postAPI(
      //       ApiConst.cancelBooking, // Assuming an endpoint for cancelling bookings
      //       formData,
      //     );

      //     final data = response.data;

      //     if (data["status"] != null && data["status"]["success"] == true) {
      //       // Fetch updated bookings after cancellation
      //       add(FetchBookingsEvent());
      //       emit(BookingCancelledSuccess(message: "Booking cancelled successfully"));
      //     } else {
      //       final message = data["status"]?["message"] ?? "Failed to cancel booking";
      //       emit(BookingListFailure(error: message));
      //     }
      //   } catch (e) {
      //     emit(BookingListFailure(error: "Something went wrong. Please try again."));
      //   }
    });
  }
}

class Booking {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;

  Booking({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
