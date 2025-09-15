// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
// import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
// import 'package:ridebooking/models/available_trip_data.dart';
// import 'package:ridebooking/models/passenger_model.dart';
// import 'package:ridebooking/repository/ApiConst.dart';
// import 'package:ridebooking/repository/ApiRepository.dart';
// import 'package:ridebooking/utils/session.dart';

// class BookingBloc extends Bloc<BookingEvent,BookingState> {
//   Availabletrips tripData;

// BookingBloc(this.tripData) : super(BookingInitial()) {

//   on<OnContinueButtonClick>((event,emit){
//     getTentativeBooking(
//       event.bpoint!,event.noofseats!,event.totalfare!,event.selectedPassenger!
//     );

//   });

// }

//   getTentativeBooking(int bpoint,int noofseats,int totalfare,List<Passenger> selectedPassenger) async{

//      emit(BookingLoading());

//   try {

// var formData = {
//   "routeid": tripData.routeid,
//   "tripid": tripData.tripid,
//   "bpoint": bpoint,
//   "noofseats": noofseats,
//   "mobileno": "8305933803",
//   "email": "aadityagupta778@gmail.com",
//   "totalfare": totalfare,
//   "bookedat": DateFormat('yyyy-MM-dd').format(DateTime.now()),
//   "seatInfo": {
//   "passengerInfo": selectedPassenger.map((p) => p.toJson()).toList()
//   },
//   "opid": "VGT"
// };

//     var response = await ApiRepository.postAPI(ApiConst.getTentativeBooking,formData);

//     final data = response.data; // ✅ Extract actual response map

//     if (data["status"] != null && data["status"]["success"] == true) {

//         await Session().setPnr(data["BookingInfo"]["PNR"]);

//       emit(BookingLoaded());
//     } else {
//       final message = data["status"]?["message"] ?? "Failed to load stations";
//       emit(BookingFailure(error: message));
//     }
//   } catch (e) {
//     print("Error in getAllStations: $e");
//     emit(BookingFailure(error: "Something went wrong. Please try again."));
//   }
//   }

// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/booking_details.dart';
import 'package:ridebooking/models/create_order_data_model.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/models/ticket_details_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Availabletrips tripData;
  final String paymentVerified;
  TicketDetailsModel? ticketDetails;
  String userId = "";
  String? pnr;
  BookingBloc(this.tripData, this.paymentVerified) : super(BookingInitial()) {
    on<OnContinueButtonClick>(_onContinueButtonClick);
    on<ShowTicket>(_showTicketDetails);

    // on<OnPaymentVerification>((event, emit) => ApiClient().paymentVerification(event.response!, event, emit),);
    // paymentVerified == "Payment successful." ? confirmTentativeBooking() : "";
  }

  // Refactored event handler (async!)
  Future<void> _onContinueButtonClick(
    OnContinueButtonClick event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final formData = {
        "routeid": tripData.routeid,
        "tripid": tripData.tripid,
        "bpoint": event.bpoint!,
        "noofseats": event.noofseats!,
        "mobileno": await Session().getPhoneNo(), //globals.phoneNo,
        "email": await Session().getEmail(), // globals.email,
        "totalfare": event.totalfare! + (event.totalfare! * 0.05),
        "bookedat": globals.selectedDate,
        "seatInfo": {
          "passengerInfo": event.selectedPassenger!
              .map(
                (p) => p.toJson()
                  ..update('fare', (value) => (value ?? 0) + (value * 0.05)),
              )
              .toList(),
        },

        "opid": event.opId
        ,//"VGT",
      };

      final response = await ApiRepository.postAPI(
        ApiConst.getTentativeBooking,
        formData,
      );

      final data = response.data;

      if (data["status"] != null && data["status"]["success"] == true) {
        print('---abc------create order before call');
        createOrder(
          event.totalfare!,
          await Session().getPhoneNo() ?? "9865329568",
          await Session().getEmail(),
        );
        pnr = data["BookingInfo"]["PNR"];
        await Session().setPnr(data["BookingInfo"]["PNR"]);
        emit(BookingLoaded(fare: event.totalfare!));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }

  Future confirmTentativeBooking() async {
    // String pnr = await Session().getPnr();
    emit(BookingLoading());
    try {
      final formData = {"pnr": pnr, "opid": "VGT"};

      final response = await ApiRepository.postAPI(
        ApiConst.confirmTentative,
        formData,
      );

      final data = response.data;

      if (data["status"] != null && data["status"]["success"] == true) {
        //  ApiClient().createOrder(event.totalfare!,"8305933803","aadityagupta778@gmail.com",event,emit);

        // print("Pnr===========>>>>>${data["BookingInfo"]["PNR"]}");
        //   await Session().setPnr(data["BookingInfo"]["PNR"]);

        // emit(BookingSuccess(success: "Booking Confirm"));
        // emit(ConfirmBooking(data["BookingInfo"]["PNR"],));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking=exception=====>>>>: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }
CreateOrderDataModel? createOrderDataModel;
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
        "paymentMode": "payu",//"razorpay",
        "email": email,
      };
      print('---abc---2---create order inside call');

      final response = await ApiRepository.postAPI(
        ApiConst.createOrder,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      final data = response.data;
      print('---abc------create order inside call');

      print("Response from createorder api====>>>> $data");

      createOrderDataModel = CreateOrderDataModel.fromJson(data) ;      

      if (data["status"] == 1) {
        // userId = data["data"]["user_id"];
        // print("user_id = ${userId} order_id = ${data["data"]["order_id"]}");
        Future.delayed(Duration(microseconds: 500));
        // emit(RazorpaySuccessState(razorpay_order_id: data["data"]["order_id"]));
        emit(PayUSuccessState(createOrderDataModel: createOrderDataModel));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }

  Future<void> paymentVerification({
    PaymentSuccessResponse? paymentVerify,
    String? bpoint,
    Set<SeatModell>? selectedSeats,
    List<Passenger>? selectedPassenger,
    BpDetails? selectedBoardingPointDetails,
    DpDetails? selectedDroppingPointDetails,
  }) async {
    try {
      var formData = {
        "razorpay_order_id": paymentVerify!.orderId,
        "razorpay_payment_id": paymentVerify.paymentId,
        "razorpay_signature": paymentVerify.signature,
        "user_id": userId,
        "paymentMode":"razorpay",
        "amount":int.parse(tripData.fare!) + (int.parse(tripData.fare!) * 0.05),
      };

      final response = await ApiRepository.postAPI(
        ApiConst.paymentVerification,
        formData,
        basurl2: ApiConst.baseUrl2,
      );

      final data = response.data;

      print("Response from paymentVerification api ----------->>>> $data");

      if (data["status"] == 1) {
        confirmTentativeBooking();
        Future.delayed(Duration(milliseconds: 500));
        confirmBooking(
          tripData: tripData,
          bpoint: bpoint,
          orderId: paymentVerify.orderId,
          selectedSeats: selectedSeats,
          selectedPassenger: selectedPassenger,
          selectedBoardingPointDetails: selectedBoardingPointDetails,
          selectedDroppingPointDetails: selectedDroppingPointDetails,
        );
        emit(BookingLoaded());
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
    }
  }

  Future<void> confirmBooking({
    Availabletrips? tripData,
    String? bpoint,
    Set<SeatModell>? selectedSeats,
    List<Passenger>? selectedPassenger,
    String? orderId,
    BpDetails? selectedBoardingPointDetails,
    DpDetails? selectedDroppingPointDetails,

  }) async {
    try {
      var formData = {
        "razorpay_order_id": orderId,
        "pnr": pnr,
        "routeid": tripData!.routeid,
        "tripid": tripData.tripid,
        "bpoint": bpoint,
        "noofseats": selectedSeats!.length,
        "boarding_point": {
          "id": selectedBoardingPointDetails!.id,
          "name": selectedBoardingPointDetails.address,
          "time": selectedBoardingPointDetails.boardtime != null
              ? DateFormat('hh:mm a  dd MMM yyyy').format(
                  DateTime.parse(
                    selectedBoardingPointDetails.boardtime.toString(),
                  ),
                )
              : '--:--',
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
        },
        "operatorName": tripData.operatorname,
        "bustype": tripData.bustype,
        "seattype": tripData.seattype,
        "from": tripData.src,
        "to": tripData.dst,
        "paymentMode":"razorpay",
        // "mobileno": await Session().getPhoneNo(),
        // "email": await Session().getEmail(),
        "totalfare":
            (selectedSeats.length * int.parse(tripData.fare.toString()))
                .toInt() +
            (selectedSeats.length * int.parse(tripData.fare.toString()) * 0.05),
        "bookedat": globals
            .selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "ticketid":
            "TU${globals.dateForTicket}", //"ticket_5906_149424_20250804074906571",
        "passengerInfo": selectedPassenger!
            .map(
              (p) =>
                  p.toJson()
                    ..update('fare', (value) => (value ?? 0) + (value * 0.05)),
            )
            .toList(),

        "opid": "VGT",
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
        emit(ConfirmBooking(selectedPassenger.first.name, data["data"]["pnr"],"TU${globals.dateForTicket}"));
      } else {
        final message = data["message"] ?? "Failed to load data";
        emit(BookingFailure(error: message));
      }

      //   final data = response.data;

      //  print("Response from confirmbooking api ----------->>>> $data");

      //  return data;
    } catch (e) {
      print("Error in confirmTentativeBooking: $e");
    }
  }

  Future<void> _showTicketDetails(
    ShowTicket event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      var formData = {"opid": "VGT", "pnr": event.pnr};

      
      var bookingResponse = await ApiRepository.getAPI(
        ApiConst.bookingTicketDetails.replaceAll("{ticketId}", event.ticketId!),basurl2:ApiConst.baseUrl2,
      );

      print(" Response from booking details api new ----------->>>> ${bookingResponse.data}");
      BookingDetails? bookingData = BookingDetails.fromJson(bookingResponse.data);

print(" Response from booking details api new ----------->>>> ${bookingData.message}");

      final response = await ApiRepository.postAPI(
        ApiConst.ticketDetails.replaceAll(
          "apiagent",
          event.userName!.replaceAll(" ", ""),
        ),
        formData,
      );

      final data = response.data;

      print('--- show ticket ====>>>>>>>${data}');

      ticketDetails = TicketDetailsModel.fromJson(data);

      if (data["status"] != null && data["status"]["success"] == true) {
        print('---abc------create order before call');
        // pnr=data["BookingInfo"]["PNR"];
        // await Session().setPnr(data["BookingInfo"]["PNR"]);

        emit(
          ShowTicketState(
            ticketDetails!.ticketDetails,
            event.tripData!,
            event.dropingPoint,
            bookingData.data
          ),
        );
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }
}
