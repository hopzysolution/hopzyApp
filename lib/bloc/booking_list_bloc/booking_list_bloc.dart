

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';

class BookingListBloc extends Bloc<BookingListEvent, BookingListState> {
  String ticketId="";
  BookingListBloc() : super(BookingListInitial()) {
    on<FetchBookingsEvent>((event, emit) async {
      // await fetchBookingList(emit);
    });

    on<FetchCancelDetailsEvent>((event, emit) async {
      emit(BookingListLoading());
      try {
        var formData = {
          "opid": "VGT",
          "pnr": event.pnr,
          "seatno": event.seatNo,
        };
          ticketId=event.ticketId;
        //hopzy cancel Api yet to call

        var response = await ApiRepository.postAPI(
          "${ApiConst.cancelBooking}",
          formData,
        );

        print("------------------cancel------data)-${response}-");
        final data = response.data;

        if (data["status"]["success"] == true) {
        // print("------------------cancel------response)-${data}-");

          final cancelDetails = CancelDetails.fromJson(data["cancel"]);
          emit(CancelDetailsLoaded(cancelDetails: cancelDetails,pnr: event.pnr));
        } else {
          final message =
              data["status"]?["message"] ?? "Failed to fetch cancel details";
          emit(BookingListFailure(error: message));
        }
      } catch (e) {
        print("------------------cancel------error)-${e}-");
        emit(
          BookingListFailure(error: "Something went wrong. Please try again."),
        );
      }
    });

    on<CancelBookingEvent>((event, emit) async {
      emit(BookingListLoading());
      try {
        var formData = {
          "opid": "VGT",
          "pnr": event.pnr,
          "seatno": event.seatNo,
        };

        var response = await ApiRepository.postAPI(
          "${ApiConst.confirmCancelBooking}",
          formData,
        );

        final data = response.data;

        if (data["status"]?["success"] == true) {

         await cancelHopzyBooking(ticketId);
          // Fetch updated bookings after cancellation
          // await fetchBookingList(emit);
          emit(
            BookingCancelledSuccess(message: "Booking cancelled successfully"),
          );
          await fetchBookingList();
          
        } else {
          final message =
              data["status"]?["message"] ?? "Failed to cancel booking";
          emit(BookingListFailure(error: message));
        }
      } catch (e) {
        emit(
          BookingListFailure(error: "Something went wrong. Please try again."),
        );
      }
    });
    fetchBookingList();
  }

  fetchBookingList() async {
    // Future<void> fetchBookingList(Emitter<BookingListState> emit) async {
    String? phoneNumber = await Session().getPhoneNo();
    emit(BookingListLoading());
    try {
      var response = await ApiRepository.getAPI(
        ApiConst.getUserBookings.replaceAll("{phoneNumber}",phoneNumber!.replaceAll("+", "")), //?page=1&limit=10",
        basurl2: ApiConst.baseUrl2,
      );
      final data = response.data;
      print("------------------get user booking------data)-${data}-");

      if (data["status"] == 1 &&
          data["message"] == "Bookings fetched successfully.") {
        final bookings = (data["data"]["bookings"] as List)
            .map((json) => Booking.fromJson(json))
            .toList();
        
        emit(BookingListLoaded(bookings: bookings));
      } else {
        final message = data["message"] ?? "Failed to load bookings";
        emit(BookingListFailure(error: message));
      }
    } catch (e) {
      emit(
        BookingListFailure(error: "Something went wrong. Please try again."),
      );
    }
  }

  cancelHopzyBooking(String ticketId) async {
    // Future<void> fetchBookingList(Emitter<BookingListState> emit) async {
    emit(BookingListLoading());
    try {

      var formData={
              "ticketid": ticketId,
              "cancelledAt": DateFormat(
  'yyyy-MM-dd',
).format(DateTime.now())
      };


      var response = await ApiRepository.postAPI(
        "${ApiConst.cancelHopzyBooking}", //?page=1&limit=10",
        basurl2: ApiConst.baseUrl2,formData
      );
      final data = response.data;
      print("------------------Hopzy cancel booking------data)-${data}-");

      // if (data["status"] == 1 &&
      //     data["message"] == "Bookings fetched successfully.") {
        


      // } else {
      //   final message = data["message"] ?? "Failed to load bookings";
      //   emit(BookingListFailure(error: message));
      // }
    } catch (e) {
      emit(
        BookingListFailure(error: "Something went wrong. Please try again."),
      );
    }
  }
}

class Booking {
  final String id;
  final String ticketId;
  final String pnr;
  final String routeId;
  final String tripId;
  final String boardingPoint;
  final int numberOfSeats;
  final int totalFare;
  final String bookedAt;
  final String status;
  final User user;
  final Payment payment;
  final List<Passenger> passengers;

  Booking({
    required this.id,
    required this.ticketId,
    required this.pnr,
    required this.routeId,
    required this.tripId,
    required this.boardingPoint,
    required this.numberOfSeats,
    required this.totalFare,
    required this.bookedAt,
    required this.status,
    required this.user,
    required this.payment,
    required this.passengers,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      pnr: json['pnr'] ?? '',
      routeId: json['routeId'] ?? '',
      tripId: json['tripId'] ?? '',
      boardingPoint: json['boardingPoint'] ?? '',
      numberOfSeats: json['numberOfSeats'] ?? 0,
      totalFare: json['totalFare'] ?? 0,
      bookedAt: json['bookedAt'] ?? '',
      status: json['status'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      payment: Payment.fromJson(json['payment'] ?? {}),
      passengers:
          (json['passengers'] as List<dynamic>?)
              ?.map((e) => Passenger.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Payment {
  final String id;
  final String razorpayOrderId;
  final int amount;
  final String currency;
  final String status;
  final String razorpayPaymentId;

  Payment({
    required this.id,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.razorpayPaymentId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'] ?? '',
      razorpayOrderId: json['razorpayOrderId'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      razorpayPaymentId: json['razorpayPaymentId'] ?? '',
    );
  }
}

class Passenger {
  final String id;
  final String booking;
  final String gender;
  final String seatNo;
  final int age;
  final int fare;

  Passenger({
    required this.id,
    required this.booking,
    required this.gender,
    required this.seatNo,
    required this.age,
    required this.fare,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['_id'] ?? '',
      booking: json['booking'] ?? '',
      gender: json['gender'] ?? '',
      seatNo: json['seatNo'] ?? '',
      age: json['age'] ?? 0,
      fare: json['fare'] ?? 0,
    );
  }
}

class CancelDetails {
  final String seatNo;
  final int ticketFare;
  final double cancellationCharge;
  final double refundAmount;

  CancelDetails({
    required this.seatNo,
    required this.ticketFare,
    required this.cancellationCharge,
    required this.refundAmount,
  });

  factory CancelDetails.fromJson(Map<String, dynamic> json) {
    return CancelDetails(
      seatNo: json['seatNo'] ?? '',
      ticketFare: json['ticketfare'] ?? 0,
      cancellationCharge: json['cancellationcharge'] ?? 0,
      refundAmount: json['refundamount'] ?? 0,
    );
  }
}
