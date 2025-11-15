import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';

class BookingListBloc extends Bloc<BookingListEvent, BookingListState> {
  String ticketId = "";
  String opid = "";
  String ticketCode = "";
  String provider = "";
  double cca = 0;
  String ctpc = "";
  String pnr = "";
  List<String> seatCodeList = [];
  List<String> passengerIds = [];

  BookingListBloc() : super(BookingListInitial()) {
    on<FetchBookingsEvent>((event, emit) async {
      await fetchBookingList();
    });

    on<FetchCancelDetailsEvent>((event, emit) async {
      emit(BookingListLoading());
      try {
        print("------trying to cancel");
        // Store booking details for later use
        // Step 0️⃣: Extract booking data
        final booking = event.booking;
        ticketId = booking.ticketId;
        ticketCode = booking.ticketCode ?? "";
        provider = booking.provider ?? "";
        opid = booking.opid ?? "";
        pnr = booking.pnr;


        // Collect seat codes and passenger IDs

        seatCodeList = event.seatNo
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        // passengerIds = selectedPassengers.map((p) => p.id).toList();
        // 3️⃣ Extract only matching passenger IDs
        final selectedPassengers = booking.passengers.where((p)=>seatCodeList.contains(p.seatNo)).toList();
        passengerIds = selectedPassengers.map((p) => p.id).toList();

        print("✅ Selected seatNo list: $seatCodeList");
        print("✅ Matched passenger IDs: $passengerIds");
        if (opid.isEmpty ||
            pnr.isEmpty ||
            seatCodeList.isEmpty ||
            passengerIds.isEmpty) {
          emit(
            BookingListFailure(error: "Missing passenger data. Cannot cancel."),
          );
          return;
        }
        // STEP 1️⃣ - Calculate refund for selected passengers
        double totalFare = 0, totalRefund = 0, totalCancelCharges = 0;

        for (final p in selectedPassengers) {
          final result = _calculateRefund(
            p.fare.toDouble() ?? 0,
            booking.boardingPoint?['time'],
          );
          totalFare += result['fare']!;
          totalRefund += result['refundAmount']!;
          totalCancelCharges += result['cancelCharge']!;
        }

        final refundPercentage = totalFare > 0
            ? (totalRefund / totalFare) * 100
            : 0;
        final cancelledAt = DateFormat("dd/MM/yyyy").format(DateTime.now());

        // ✅ Step 2️⃣ - Prepare Admin payload (final confirmation payload)
        // final confirmAdminPayload = {
        //   "ticketid": ticketId,
        //   "passengers": passengerIds,
        //   "cancelledAt": cancelledAt,
        //   "refundPercentage": refundPercentage.round(),
        //   "refundAmount": totalRefund.round(),
        //   "cancellationCharges": totalCancelCharges.round(),
        //   "mode": "wallet",
        // };

        // === Step 3️⃣: Get cancellation charge details from API ===
        Map<String, dynamic> cancelChargePayload;
        if (provider == "ezeeinfo") {
          cancelChargePayload = {"ticketCode": ticketCode, "provider": "ezeeinfo"};
        } else if (provider == "bitla") {
          cancelChargePayload = {"pnr": pnr, "seatno": seatCodeList, "provider": "bitla"};
        } else {
          cancelChargePayload = {"opid": opid, "pnr": pnr, "seatno": seatCodeList, "provider": "vaagai"};
        }


        var cancelResponse = await ApiRepository.postAPI(
          ApiConst.cancelBooking,
          cancelChargePayload,
          basurl2: ApiConst.baseUrl2,
        );


        print("------------------cancel booking response: ${cancelResponse}");


        if (cancelResponse.data["status"] == 1) {
          final data = cancelResponse.data["data"];
          final result = data["result"];
          final cancelInfo = result["is_ticket_cancellable"];

          if (cancelInfo != null && cancelInfo["is_cancellable"] == true) {
            final cancelDetails = CancelDetails(
              seatNo: seatCodeList,
              ticketFare: 0, // ❗API doesn’t return fare, set manually if you have it
              cancellationCharge: (cancelInfo["cancellation_charges"] ?? 0).toDouble(),
              refundAmount: (cancelInfo["refund_amount"] ?? 0).toDouble(),
            );

            emit(
                CancelDetailsLoaded(
                  cancelDetails: cancelDetails,
                  pnr: pnr,
                  booking: booking,
                ),
            );
          } else {
            emit(BookingListFailure(error: "No ticket details found"));
          }
        } else {
          final message =
              cancelResponse.data["message"] ??
              "Failed to fetch cancel details";
          emit(BookingListFailure(error: message));
        }
      } catch (e, stacktrace) {
        print("------------------cancel error: $stacktrace");
        emit(
          BookingListFailure(error: "Something went wrong. Please try again."),
        );
      }
    });

    on<CancelBookingEvent>((event, emit) async {
      emit(BookingListLoading());
      try {
        // Step 2: Confirm cancellation with the bus operator
        // === Step 4️⃣: Confirm cancellation with provider ===

        Map<String, dynamic> confirmCancelPayload;
        if (provider == "ezeeinfo") {
          confirmCancelPayload = {
            "seatCodeList": seatCodeList,
            "ticketCode": ticketCode,
            "pnr": pnr,
            "provider": "ezeeinfo"
          };
        } else if (provider == "bitla") {
          confirmCancelPayload = {"pnr": pnr, "seatno": seatCodeList, "provider": "bitla"};
        } else {
          confirmCancelPayload = {"opid": opid, "pnr": pnr, "seatno": seatCodeList, "provider": "vaagai"};
        }

        var confirmResponse = await ApiRepository.postAPI(
          ApiConst.confirmCancelBooking,
          confirmCancelPayload,
          basurl2: ApiConst.baseUrl2,
        );

        print(
          "------------------confirm cancel response: ${confirmResponse.data}",
        );

        if (confirmResponse.data["status"] == 1) {
          final result = confirmResponse.data["data"]["result"];
          final cancelTicket = result["cancel_ticket"];

          final totalRefundAmount = cancelTicket["refund_amount"] ?? 0;
          final cancellationCharge = cancelTicket["cancellation_charges"] ?? 0;

          // Step 3: Update booking status in Hopzy system
          await cancelHopzyBooking(
            ticketId,
            passengerIds,
            totalRefundAmount.toDouble(),
            cancellationCharge.toDouble(),
          );

          emit(
            BookingCancelledSuccess(message: "Booking cancelled successfully"),
          );

          // Refresh the booking list
          await fetchBookingList();
        } else {
          final message =
              confirmResponse.data["message"] ?? "Failed to cancel booking";
          emit(BookingListFailure(error: message));
        }
      } catch (e) {
        print("------------------cancel booking error: $e");
        emit(BookingListFailure(error: "Something went wrong. Please try ."));
      }
    });

    fetchBookingList();
  }

  Map<String, double> _calculateRefund(double fare, String? boardingTimeStr) {
    DateTime? boardingTime = DateTime.tryParse(boardingTimeStr ?? "");
    final now = DateTime.now();
    double hoursBeforeDeparture = 0;

    if (boardingTime != null) {
      hoursBeforeDeparture = boardingTime.difference(now).inHours.toDouble();
    }

    double refundPercentage;
    if (hoursBeforeDeparture >= 24) {
      refundPercentage = 80; // 20% cancel charge
    } else if (hoursBeforeDeparture >= 12) {
      refundPercentage = 50;
    } else {
      refundPercentage = 0;
    }

    double refundAmount = (fare * refundPercentage) / 100;
    double cancelCharge = fare - refundAmount;

    return {
      "fare": fare,
      "refundAmount": refundAmount,
      "cancelCharge": cancelCharge,
    };
  }

  Future<void> fetchBookingList() async {
    print("Inside fetching booking list");
    String? phoneNumber = await Session().getPhoneNo();
    emit(BookingListLoading());
    try {
      var response = await ApiRepository.getAPI(
        ApiConst
            .getUserBookings, //.replaceAll("{phoneNumber}", phoneNumber!.replaceAll("+", "")),
        basurl2: ApiConst.baseUrl2,
      );
      final data = response.data;
      print("------------------get user bookings data: ${data}");

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
    } catch (e, stackTrace) {
      print("------------------fetch bookings error: $e");
      print("------------------StackTrace: $stackTrace");
      emit(
        BookingListFailure(error: "Something went wrong. Please try again."),
      );
    }
  }

  Future<void> cancelHopzyBooking(
    String ticketId,
    List<String> passengerIds,
    double refundAmount,
    double cancellationCharges,
  ) async {
    try {
      // Calculate refund percentage (approximation)
      double totalFare = refundAmount + cancellationCharges;
      double refundPercentage = (refundAmount / totalFare * 100)
          .roundToDouble();

      var formData = {
        "ticketid": ticketId,
        "passengers": passengerIds,
        "cancelledAt": DateFormat('dd/MM/yyyy').format(DateTime.now()),
        "refundPercentage": refundPercentage.toInt(),
        "refundAmount": refundAmount.toInt(),
        "cancellationCharges": cancellationCharges.toInt(),
        "mode": "wallet", // You might want to make this configurable
      };

      var response = await ApiRepository.postAPI(
        ApiConst.cancelHopzyBooking,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      print(
        "------------------Hopzy cancel booking response: ${response.data}",
      );
    } catch (e) {
      print("------------------Hopzy cancel error: $e");
      // Don't emit error here as the main cancellation was successful
    }
  }
}

// Updated Booking model to include new fields
class Booking {
  final String id;
  final String ticketId;
  final String? ticketCode;
  final String? provider;
  final String pnr;
  final String? operatorpnr;
  final String? routeId;
  final String? tripId;
  final Map<String, dynamic>? boardingPoint;
  final Map<String, dynamic>? droppingPoint;
  final String? from;
  final String? opid;
  final String? to;
  final String? bustype;
  final String? seattype;
  final int numberOfSeats;
  final int totalFare;
  final String bookedAt;
  final String status;
  final String? cancelledAt;
  final CancelUser user;
  final CancelPayment payment;
  final List<CancelPassenger> passengers;

  Booking({
    required this.id,
    required this.ticketId,
    this.ticketCode,
    this.provider,
    required this.pnr,
    this.operatorpnr,
    this.routeId,
    this.tripId,
    this.boardingPoint,
    this.droppingPoint,
    this.from,
    this.to,
    this.opid,
    this.bustype,
    this.seattype,
    required this.numberOfSeats,
    required this.totalFare,
    required this.bookedAt,
    required this.status,
    this.cancelledAt,
    required this.user,
    required this.payment,
    required this.passengers,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      ticketCode: json['ticketCode'],
      // provider: json['provider'],
      provider: json['provider'],
      pnr: json['pnr'] ?? '',
      operatorpnr: json['operatorpnr'],
      routeId: json['routeId'],
      tripId: json['tripId'],
      boardingPoint: json['boarding_point'],
      droppingPoint: json['dropping_point'],
      from: json['from'],
      to: json['to'],
      opid: json['opid'],
      bustype: json['bustype'],
      seattype: json['seattype'],
      numberOfSeats: (json['numberOfSeats'] as num?)?.toInt() ?? 0,
      totalFare: (json['totalFare'] as num?)?.toInt() ?? 0,

      bookedAt: json['bookedAt'] ?? '',
      status: json['status'] ?? '',
      cancelledAt: json['cancelledAt'],
      user: CancelUser.fromJson(json['user'] ?? {}),
      payment: CancelPayment.fromJson(json['payment'] ?? {}),
      passengers:
          (json['passengers'] as List<dynamic>?)
              ?.map((e) => CancelPassenger.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Helper method to get boarding point name
  String get boardingPointName {
    if (boardingPoint != null && boardingPoint!['name'] != null) {
      return boardingPoint!['name'];
    }
    return 'N/A';
  }
}

class CancelUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  CancelUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory CancelUser.fromJson(Map<String, dynamic> json) {
    return CancelUser(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class CancelPayment {
  final String id;
  final String? razorpayOrderId;
  final String? razorpayCancelPaymentId;
  final String? payuTxnId;
  final int? payuAmount;
  final int amount;
  final String currency;
  final String status;

  CancelPayment({
    required this.id,
    this.razorpayOrderId,
    this.razorpayCancelPaymentId,
    this.payuTxnId,
    this.payuAmount,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory CancelPayment.fromJson(Map<String, dynamic> json) {
    return CancelPayment(
      id: json['_id'] ?? '',
      razorpayOrderId: json['razorpayOrderId'],
      razorpayCancelPaymentId: json['razorpayCancelPaymentId'],
      payuTxnId: json['payuTxnId'],
      payuAmount: json['payuAmount'],
      amount: json['amount'] ?? json['payuAmount'] ?? 0,
      currency: json['currency'] ?? 'INR',
      status: json['status'] ?? '',
    );
  }
}

class CancelPassenger {
  final String id;
  final String booking;
  final String name;
  final String gender;
  final String seatCode;
  final String seatNo;
  final int age;
  late final int fare;
  final String status;

  CancelPassenger({
    required this.id,
    required this.booking,
    required this.name,
    required this.gender,
    required this.seatCode,
    required this.seatNo,
    required this.age,
    required this.fare,
    required this.status,
  });

  factory CancelPassenger.fromJson(Map<String, dynamic> json) {
    return CancelPassenger(
      id: json['_id'] ?? '',
      booking: json['booking'] ?? '',
      name: json['Name'] ?? json['name'] ?? '',
      gender: json['gender'] ?? '',
      seatCode: json['seatCode'] ?? '',
      seatNo: json['seatNo'] ?? '',
      age: json['age'] ?? 0,
      fare: (json['fare'] as num?)?.toInt() ?? 0,

      status: json['status'] ?? '',
    );
  }
}

class CancelDetails {
  final List seatNo;
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
      cancellationCharge: (json['cancellationcharge'] ?? 0).toDouble(),
      refundAmount: (json['refundamount'] ?? 0).toDouble(),
    );
  }
}
