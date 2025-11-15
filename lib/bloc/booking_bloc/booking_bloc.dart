import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
import 'package:ridebooking/commonWidgets/gst_form_widget.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/booking_details.dart';
import 'package:ridebooking/models/create_order_data_model.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/profile_data_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/models/tantative_booking_data_model.dart';
import 'package:ridebooking/models/ticket_details_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Trips tripData;
  final String paymentVerified;
  TicketDetailsModel? ticketDetails;
  String userId = "";
  String? pnr;

  BookingBloc(this.tripData, this.paymentVerified) : super(BookingInitial()) {
    on<OnContinueButtonClick>(_onContinueButtonClick);
    // on<ShowTicket>(_showTicketDetails);

    // on<OnPaymentVerification>((event, emit) => ApiClient().paymentVerification(event.response!, event, emit),);
    // paymentVerified == "Payment successful." ? confirmTentativeBooking() : "";
    getProfile();
  }

  ProfileDataModel? profileDataModel;

  String? bpoint, phone;
  Set<SeatModell>? selectedSeats;
  List<Passenger>? selectedPassenger;
  BpDetails? selectedBoardingPointDetails;
  DpDetails? selectedDroppingPointDetails;

  Future<void> getProfile({String? phoneNumb = null}) async {
    try {
      if (phoneNumb == null) {
        phone = await Session().getPhoneNo();
      } else {
        phone = phoneNumb;
      }
      print("phone number in get profile--------->>>>>$phone");

      if (phone != null) {
        var formData = {"phone": phone};

        var response = await ApiRepository.postAPI(
          ApiConst.getProfileApi,
          formData,
          basurl2: ApiConst.baseUrl2,
        );

        final data = response.data;
        print("profile data model before condition-------->>>>${data}");

        if (data["status"] != null && data["status"] == 1) {
          profileDataModel = ProfileDataModel.fromJson(data);
          Session.saveProfileData(profileDataModel!);
          print(
            "profile data model-------->>>>${profileDataModel!.data!.wallet}",
          );
        } else {
          throw Exception("Failed to load profile");
        }
      }
    } catch (e) {
      print("Error in getProfile: $e");
      // Re-throw to handle in _initializeData
    }
  }

  TantativeBookingDataModel? tantativeBookingDataModel;
  String ticketCode = "";
  // Refactored event handler (async!)
  Future<void> _onContinueButtonClick(
    OnContinueButtonClick event,
    Emitter<BookingState> emit,
  ) async
  {
    bpoint = event.bpoint.toString();
    selectedSeats = event.selectedSeats;
    selectedPassenger = event.selectedPassenger;
    selectedBoardingPointDetails = event.selectedBoardingPointDetails;
    selectedDroppingPointDetails = event.selectedDroppingPointDetails;

    emit(BookingLoading());
    int count = 0;
    try {
      final mobileRaw = await Session().getPhoneNo();
      final mobile = mobileRaw?.replaceAll("+91", ""); // remove +91

      final totalFare = event.totalfare!;
      final gst = (totalFare * 0.05).round(); // ✅ GST as integer
      final finalFare = (totalFare + gst).round(); // ✅ total as integer

      final formData = {
        "basefare": selectedSeats!.first.fare,
        if (tripData.routeid != "null")"routeid": tripData.routeid,
        "tripid": tripData.tripid,
        "bpoint": event.selectedBoardingPointDetails!.id,
        "dpoint": event.selectedDroppingPointDetails!.id,
        "fromStation": tripData.srcId,
        "toStation": tripData.dstId,
        "noofseats": event.noofseats!,
        "mobileno": mobile.toString(),
        "email": await Session().getEmail(),
        "totalfare": finalFare,  // ✅ int
        "bookedat": globals.selectedDate,
        "gstamount": gst,        // ✅ int
        "cancellationpolicy": tripData.cancellationpolicy?.toJson(),

        "seatInfo": {
          "passengerInfo": (tripData.provider == "bitla" ||
              tripData.provider == "ezeeinfo")
              ? event.selectedPassenger!.map((p) {
            final originalFare = p.fare ?? 0;
            final gstAmount = (originalFare * 0.05).round(); // ✅ int
            final newFare = (originalFare + gstAmount).round(); // ✅ int

            final gender = (p.gender?.toLowerCase() == "male") ? "M" : "F";

            return p.toJson()
              ..['ofare'] = originalFare
              ..['gst'] = gstAmount
              ..['fare'] = newFare
              ..['gender'] = gender
            // ✅ DO NOT change seatCode as requested
              ..['seatCode'] =event.selectedSeats!.first.seatCode;
          }).toList()
              : event.selectedPassenger!.map((p) {
            final originalFare = p.fare ?? 0;
            final gstAmount = (originalFare * 0.05).round();
            final updatedFare = (originalFare + gstAmount).round();

            final gender = (p.gender?.toLowerCase() == "male") ? "M" : "F";

            return p.toJson()
              ..update('fare', (_) => updatedFare)
              ..['gst'] = gstAmount
              ..['gender'] = gender;
          }).toList(),
        },

        "opid": event.opId,
        "provider": tripData.provider,

      };

      print('📦 tripData${jsonEncode(tripData)}');
      print('This is route id ${jsonEncode(tripData.routeid)}');
      final response = await ApiRepository.postAPI(
        ApiConst.getTentativeBooking,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      if (response == null) {
        emit(
          BookingFailure(error: "No response from server. Please try again."),
        );
        return;
      }

      // Handle HTTP error responses
      if (response is Map && response['status'] == false) {
        emit(BookingFailure(error: response['message'] ?? "Server error."));
        return;
      }

      final data = response.data;
      tantativeBookingDataModel = TantativeBookingDataModel.fromJson(data);

      print('--- Tentative Booking Response ---');
      print(
        "-------------=-->>>>${selectedBoardingPointDetails!.boardtime.toString()}",
      );
      print(data);

      if (tantativeBookingDataModel?.status == 1) {
        print('✅ Tentative booking successful. Proceeding to payment...');

        pnr = tantativeBookingDataModel!.data!.pnr;

        print(pnr);

        await Session().setPnr(pnr!);
        createOrder(
          event.totalfare!,
          await Session().getPhoneNo() ?? "9865329568",
          await Session().getEmail(),
        );

        emit(BookingLoaded(fare: event.totalfare!));
      } else {
        final message =
            tantativeBookingDataModel?.message ??
            "Booking failed. Please try again.";
        emit(BookingFailure(error: message));
      }
    } catch (e, stacktrace) {
      print("❌ Error in getTentativeBooking: $e");
      print("🪵 Stacktrace: $stacktrace");

      // Handle DioException separately for clear error message
      if (e is DioException) {
        String msg = "Something went wrong. Please try again.";
        if (e.response != null) {
          msg =
              e.response?.data?['message'] ??
              "Server error (${e.response?.statusCode}). Please try again later.";
        } else if (e.type == DioExceptionType.connectionError) {
          msg = "Network error. Check your internet connection.";
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          msg = "Request timeout. Please try again later.";
        }
        emit(BookingFailure(error: msg));
      } else {
        emit(
          BookingFailure(
            error: "Unexpected error occurred. Please try again later.",
          ),
        );
      }
    }
  }

  Future confirmTentativeBooking() async {
    // String pnr = await Session().getPnr();
    emit(BookingLoading());
    try {
      final formData = {
        "pnr": pnr,
        "ticketCode": ticketCode,
        "opid": tripData.operatorid,
        "provider": tripData.provider,
      };

      final response = await ApiRepository.postAPI(
        ApiConst.confirmTentative,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      final data = response.data;

      print(
        "------boardingTime--------->>>>>>${selectedBoardingPointDetails!.boardtime.toString()}",
      );

      if (data["status"] != null && data["status"] == 1) {
        //  ApiClient().createOrder(event.totalfare!,"8305933803","aadityagupta778@gmail.com",event,emit);

        print("Pnr===========>>>>>${jsonEncode(data)}");
        //   await Session().setPnr(data["BookingInfo"]["PNR"]);

        // emit(BookingSuccess(success: "Booking Confirm"));
        // emit(ConfirmBooking(data["BookingInfo"]["PNR"],));
      } else {
        final message = data["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in confirmTentativeBooking=exception=====>>>>: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }

  CreateOrderDataModel? createOrderDataModel;
  String? txnId = "";
  Future<void> createOrder(int fare, String phoneNo, String email) async {
    print('---abc----1--create order inside call');

    emit(BookingLoading());
    try {
      // final response = await dio.post(ApiConst.createOrder, data: {
      //        "amount": 1050,
      //   "phone": phoneNo,
      //   "email": email
      //     });
      var formData = {
        "amount": (fare + (fare * 0.05)).toInt(),
        "phone": phoneNo.contains("+91") ? phoneNo : "+91${phoneNo}",
        "paymentMode": profileDataModel!.data!.wallet! <= 0
            ? "payu"
            : profileDataModel!.data!.wallet! >= (fare + (fare * 0.05)).toInt()
            ? "wallet"
            : "mixed", //"razorpay",
        "email": email,
        "orderId": pnr,
        "walletUsed": profileDataModel!.data!.wallet!,
        "payuAmount": (fare + (fare * 0.05)).toInt(),
        // "isTestMode":"true",

        "clientType": "mobile",
      };
      print('---abc---2---create order inside call');

      final response = await ApiRepository.postAPI(
        ApiConst.createOrder,
        formData,
        basurl2: ApiConst.baseUrl2, //"https://stagingapi.hopzy.in/",//
      );

      final data = response.data;
      print("CreateOrder response: $data");
      print('---abc------create order inside call');

      print("Response from createorder api====>>>> $data");

      createOrderDataModel = CreateOrderDataModel.fromJson(data);
      txnId =
          (profileDataModel!.data!.wallet! <= 0
                  ? "payu"
                  : profileDataModel!.data!.wallet! >=
                        (fare + (fare * 0.05)).toInt()
                  ? "wallet"
                  : "mixed") ==
              "wallet"
          ? data["data"]["txnid"]
          : createOrderDataModel!.data!.payUData!.txnid!;
      if (data["status"] == 1) {
        // userId = data["data"]["user_id"];
        // print("user_id = ${createOrderDataModel!.data!.payUData!.txnid}");
        Future.delayed(Duration(microseconds: 500));

        // emit(RazorpaySuccessState(razorpay_order_id: data["data"]["order_id"]));
        if (profileDataModel!.data!.wallet! >= (fare + (fare * 0.05)).toInt()) {
          confirmTentativeBooking();
          Future.delayed(Duration(milliseconds: 500));
          confirmBooking(
            tripData: tripData,
            bpoint: bpoint,
            // orderId: paymentVerify.orderId,
            selectedSeats: selectedSeats,
            selectedPassenger: selectedPassenger,
            selectedBoardingPointDetails: selectedBoardingPointDetails,
            selectedDroppingPointDetails: selectedDroppingPointDetails,
          );
        } else {
          // print("Payment Gateway need to + ${jsonEncode(createOrderDataModel)}");
          emit(PayUSuccessState(createOrderDataModel: createOrderDataModel));

        }
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in createOrder: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }

  //   Future<void> paymentVerification({
  //     PaymentSuccessResponse? paymentVerify,
  //     String? bpoint,
  //     Set<SeatModell>? selectedSeats,
  //     List<Passenger>? selectedPassenger,
  //     BpDetails? selectedBoardingPointDetails,
  //     DpDetails? selectedDroppingPointDetails,
  //   }) async {
  //     try {
  //       var formData = {
  //   "mihpayid": "403993715521234567",
  //   "txnid": "txn_1756985376564",
  //   "status": "success",
  //   "hash": "75b93a71f923425cc780382d43bedd28f902d6f831e0a0a15d7db97f51eb68c8d97f33d71ed3bc5f999695fd72c8e13f99905d053208965e1af59b9787e33947"
  // };

  //       final response = await ApiRepository.postAPI(
  //         ApiConst.paymentVerification,
  //         formData,
  //         basurl2: ApiConst.baseUrl2,
  //       );

  //       final data = response.data;

  //       print("Response from paymentVerification api ----------->>>> $data");

  //       if (data["status"] == 1) {
  //         confirmTentativeBooking();
  //         Future.delayed(Duration(milliseconds: 500));
  //         confirmBooking(
  //           tripData: tripData,
  //           bpoint: bpoint,
  //           // orderId: paymentVerify.orderId,
  //           selectedSeats: selectedSeats,
  //           selectedPassenger: selectedPassenger,
  //           selectedBoardingPointDetails: selectedBoardingPointDetails,
  //           selectedDroppingPointDetails: selectedDroppingPointDetails,
  //         );
  //         emit(BookingLoaded());
  //       } else {
  //         final message = data["status"]?["message"] ?? "Failed to load stations";
  //         emit(BookingFailure(error: message));
  //       }
  //     } catch (e) {
  //       print("Error in paymentVerification: $e");
  //     }
  //   }

  Future<void> confirmBooking({
    Trips? tripData,
    String? bpoint,
    Set<SeatModell>? selectedSeats,
    List<Passenger>? selectedPassenger,
    String? orderId,
    BpDetails? selectedBoardingPointDetails,
    DpDetails? selectedDroppingPointDetails,
    GstDetails? gstDetails,
  }) async
  {
    // print("transaction id ----------------->>>>>${createOrderDataModel!.data!.payUData!.txnid}");
    try {
      var formData = gstDetails != null
          ? {
              // "razorpay_order_id": orderId,
              "cancellationpolicy": tripData!.cancellationpolicy,
              "paymentMode": profileDataModel!.data!.wallet! <= 0
                  ? "payu"
                  : profileDataModel!.data!.wallet! >=
                        (int.parse(tripData!.fare!) +
                                (int.parse(tripData.fare!) * 0.05))
                            .toInt()
                  ? "wallet"
                  : "mixed",
              "txnid": txnId, //createOrderDataModel!.data!.payUData!.txnid,
              "operatorpnr": pnr,
              "routeid": tripData!.routeid,
              "tripid": tripData.tripid,
              "bpoint": bpoint,
              "noofseats": selectedSeats!.length,
              "boarding_point": {
                "id": selectedBoardingPointDetails!.id,
                "name": selectedBoardingPointDetails.address,
                "time": selectedBoardingPointDetails.boardtime != null
                    ? DateFormat('hh:mm').format(
                        DateTime.parse(
                          selectedBoardingPointDetails.boardtime.toString(),
                        ),
                      )
                    : '--:--',
                "address": selectedBoardingPointDetails.address,
                "contactno": selectedBoardingPointDetails.contactno,
                //  "timedelay": selectedBoardingPointDetails.timedelay,
                "tripid": selectedBoardingPointDetails.id,
                "venue": selectedBoardingPointDetails.venue,
              },
              "dropping_point": {
                "id": selectedDroppingPointDetails!.id,
                "name": selectedDroppingPointDetails.stnname,
                "time": selectedDroppingPointDetails.droptime != null
                    ?
                      // DateFormat('hh:mm a  dd MMM yyyy').format(
                      //     DateTime.parse(
                      selectedDroppingPointDetails.droptime.toString()
                    //   ),
                    // )
                    : '--:--',
                "address": selectedDroppingPointDetails.address,
                "contactno": selectedDroppingPointDetails.contactno,
                // "timedelay": selectedDroppingPointDetails.timedelay,
                "tripid": selectedDroppingPointDetails.id,
                "venue": selectedDroppingPointDetails.venue,
              },
              "operatorName": tripData.operatorname,
              "bustype": tripData.bustype,
              "seattype": tripData.seattype,
              "from": tripData.src,
              "to": tripData.dst,
              "phone": await Session().getPhoneNo(),
              "email": await Session().getEmail(),
              "totalfare": profileDataModel!.data!.user == null
                  ? (selectedSeats.length > 1
                        ? ((selectedSeats.length *
                                  int.parse(tripData.fare.toString()))
                              .toInt() //conditon change karni hai
                              )
                        : ((int.parse(tripData.fare.toString())).toInt() -
                              (int.parse(tripData.fare.toString()) * 0.05)))
                  : ((selectedSeats.length *
                                    int.parse(tripData.fare.toString()))
                                .toInt() +
                            (selectedSeats.length *
                                int.parse(tripData.fare.toString()) *
                                0.05)) -
                        profileDataModel!.data!.wallet!,
              "bookedat": globals
                  .selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
              "ticketid":
              "TU${DateTime.now().millisecondsSinceEpoch}", //"ticket_5906_149424_20250804074906571",
              "passengerInfo": selectedPassenger!
                  .map(
                    (p) => p.toJson()
                      ..update(
                        'fare',
                        (value) => (value ?? 0) + (value * 0.05),
                      ),
                  )
                  .toList(),

              "opid": tripData.operatorid,
              "gstDetails": gstDetails,
              "pnr": pnr,
            }
          : {
              // "razorpay_order_id": orderId,
              "cancellationpolicy": tripData!.cancellationpolicy!.toJson(),
              "paymentMode": profileDataModel!.data!.wallet! <= 0
                  ? "payu"
                  : profileDataModel!.data!.wallet! >=
                        (int.parse(tripData!.fare!) +
                                (int.parse(tripData.fare!) * 0.05))
                            .toInt()
                  ? "wallet"
                  : "mixed",
              "txnid": txnId, //createOrderDataModel!.data!.payUData!.txnid,
              "operatorpnr": pnr,
              "routeid": tripData!.routeid,
              "tripid": tripData.tripid,
              "bpoint": bpoint,
              "noofseats": selectedSeats!.length,
              "boarding_point": {
                "id": selectedBoardingPointDetails!.id,
                "name": selectedBoardingPointDetails.address,
                "time": selectedBoardingPointDetails.boardtime != null
                    ?
                      // DateFormat('hh:mm').format(
                      //     DateTime.parse(
                      selectedBoardingPointDetails.boardtime.toString()
                    //   ),
                    // )
                    : '--:--',
                "address": selectedBoardingPointDetails.address,
                "contactno": selectedBoardingPointDetails.contactno,
                //  "timedelay": selectedBoardingPointDetails.timedelay,
                "tripid": selectedBoardingPointDetails.id,
                "venue": selectedBoardingPointDetails.venue,
              },
              "dropping_point": {
                "id": selectedDroppingPointDetails!.id,
                "name": selectedDroppingPointDetails.address,
                "time": selectedDroppingPointDetails.droptime != null
                    ? DateFormat('hh:mm a  dd MMM yyyy').format(
                        DateTime.parse(
                          selectedDroppingPointDetails.droptime.toString(),
                        ),
                      )
                    : '--:--',
                "address": selectedDroppingPointDetails.address,
                "contactno": selectedDroppingPointDetails.contactno,
                // "timedelay": selectedDroppingPointDetails.timedelay,
                "tripid": selectedDroppingPointDetails.id,
                "venue": selectedDroppingPointDetails.venue,
              },
              "operatorName": tripData.operatorname,
              "bustype": tripData.bustype,
              "seattype": tripData.seattype,
              "from": tripData.src,
              "to": tripData.dst,
              "phone": await Session().getPhoneNo(),
              "email": await Session().getEmail(),
              "totalfare": profileDataModel!.data!.user == null
                  ? (selectedSeats.length > 1
                        ? ((selectedSeats.length *
                                  int.parse(tripData.fare.toString()))
                              .toInt() //conditon change karni hai
                              )
                        : ((int.parse(tripData.fare.toString())).toInt() -
                              (int.parse(tripData.fare.toString()) * 0.05)))
                  : ((selectedSeats.length *
                                    int.parse(tripData.fare.toString()))
                                .toInt() +
                            (selectedSeats.length *
                                int.parse(tripData.fare.toString()) *
                                0.05)) -
                        profileDataModel!.data!.wallet!,
              "bookedat": globals
                  .selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
              "ticketid":
              "TU${DateTime.now().millisecondsSinceEpoch}", //"ticket_5906_149424_20250804074906571",
              "passengerInfo": selectedPassenger!
                  .map(
                    (p) => p.toJson()
                      ..update(
                        'fare',
                        (value) => (value ?? 0) + (value * 0.05),
                      ),
                  )
                  .toList(),

              "opid": tripData.operatorid,
              "gstDetails": gstDetails,
              "pnr": pnr,
            };

      final response = await ApiRepository.postAPI(
        ApiConst.confirmBooking,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      final data = response.data;

      print("Response from confirmbooking api ----------->>>> $data");

      //  return data;

      if (data["status"] == 1) {
        //  ApiClient().createOrder(event.totalfare!,"8305933803","aadityagupta778@gmail.com",event,emit);

        print("Pnr====confirm booking api hopzy=======>>>>>${data}");

        // await Session().setPnr(data["BookingInfo"]["PNR"]);

        // emit(BookingSuccess(success: "Booking Confirm"));
        // emit(
        //   ConfirmBooking(
        //     selectedPassenger.first.name,
        //     data["data"]["pnr"],
        //     // "TU${globals.dateForTicket}", old
        //      "TU${DateTime.now().millisecondsSinceEpoch}",
        //
        //
        // ),
        // );
        // Convert the API response to TicketDetailsModel
        final ticketJson = data["data"];

        // Create TicketDetailsModel from the API response
        // final ticketDetailsModel = TicketDetailsModel.fromJson({
        //   "status": {"success": true},
        //   "ticketDetails": ticketJson,
        // });
        print("This is ticket details: ${jsonEncode(ticketJson)}");
        // Emit ShowTicketState to navigate to trip details screen
        emit(
          ShowTicketState(
            ticketJson, // Proper TicketDetails object
            // tripData,                            // Trip data for route info
            // selectedDroppingPointDetails?.address ??
            //     selectedDroppingPointDetails?.stnname, // Dropping point
            // ticketJson,                          // Raw API response
          ),
        );

      } else {
        final message = data["message"] ?? "Failed to load data";
        emit(BookingFailure(error: message));
      }

      //   final data = response.data;

      //  print("Response from confirmbooking api ----------->>>> $data");

      //  return data;
    } catch (e,stackTrace) {
      print("Error in confirmTentativeBooking: $stackTrace");
    }
  }

  // Future<void> _showTicketDetails(
  //   ShowTicket event,
  //   Emitter<BookingState> emit,
  // ) async
  // {
  //   emit(BookingLoading());
  //   try {
  //     var formData = {"opid": event.tripData!.operatorid, "pnr": event.pnr};
  //
  //     var bookingResponse = await ApiRepository.getAPI(
  //       ApiConst.bookingTicketDetails.replaceAll("{ticketId}", event.ticketId!),
  //       basurl2: ApiConst.baseUrl2,
  //     );
  //
  //     print(
  //       " Response from booking details api new ----------->>>> ${bookingResponse.data}",
  //     );
  //     BookingDetails? bookingData = BookingDetails.fromJson(
  //       bookingResponse.data,
  //     );
  //
  //     print(
  //       " Response from booking details api new ----------->>>> ${bookingData.message}",
  //     );
  //
  //     final response = await ApiRepository.postAPI(
  //       ApiConst.ticketDetails.replaceAll(
  //         "apiagent",
  //         event.userName!.replaceAll(" ", ""),
  //       ),
  //       formData,
  //     );
  //
  //     final data = response.data;
  //
  //     print('--- show ticket ====>>>>>>>${data}');
  //
  //     ticketDetails = TicketDetailsModel.fromJson(data);
  //
  //     if (data["status"] != null && data["status"]["success"] == true) {
  //       print('---abc------create order before call');
  //       // pnr=data["BookingInfo"]["PNR"];
  //       // await Session().setPnr(data["BookingInfo"]["PNR"]);
  //
  //       emit(
  //         ShowTicketState(
  //           ticketDetails!.ticketDetails,
  //           event.tripData!,
  //           event.dropingPoint,
  //           bookingData.data,
  //         ),
  //       );
  //     } else {
  //       final message = data["status"]?["message"] ?? "Failed to load stations";
  //       emit(BookingFailure(error: message));
  //     }
  //   } catch (e) {
  //     print("Error in _showTicketDetails: $e");
  //     emit(BookingFailure(error: "Something went wrong. Please try again."));
  //   }
  // }

}
