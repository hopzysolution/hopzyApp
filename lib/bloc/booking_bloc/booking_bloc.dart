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
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Availabletrips tripData;
  final String paymentVerified;
  String userId="";
  String? pnr;
  BookingBloc(this.tripData, this.paymentVerified) : super(BookingInitial()) {
    on<OnContinueButtonClick>(_onContinueButtonClick);

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
        "mobileno": await Session().getEmail(), //globals.phoneNo,
        "email": await Session().getPhoneNo(),// globals.email,
        "totalfare": event.totalfare! + 50,
        "bookedat": globals.selectedDate,
        "seatInfo": {
          "passengerInfo": event.selectedPassenger!
              .map(
                (p) => p.toJson()..update('fare', (value) => (value ?? 0) + 50),
              )
              .toList(),
        },

        "opid": "VGT",
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
          await Session().getPhoneNo()??"9865329568",
          await Session().getEmail()
        );
        pnr=data["BookingInfo"]["PNR"];
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

        print("Pnr===========>>>>>${data["BookingInfo"]["PNR"]}");
          await Session().setPnr(data["BookingInfo"]["PNR"]);

        // emit(BookingSuccess(success: "Booking Confirm"));
        emit(ConfirmBooking());
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking=exception=====>>>>: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }
  }




Future<void> createOrder(int fare,String phoneNo,String email,
    ) async{

        print('---abc----1--create order inside call');

     emit(BookingLoading());
    try {

// final response = await dio.post(ApiConst.createOrder, data: {
//        "amount": 1050,
//   "phone": phoneNo,
//   "email": email
//     });
var formData={
       "amount": fare+50,
  "phone": phoneNo,
  "email": email
    };
        print('---abc---2---create order inside call');

      final response = await ApiRepository.postAPI(ApiConst.createOrder, formData,basurl2: ApiConst.baseUrl2);

      final data = response.data;
        print('---abc------create order inside call');

       print("Response from createorder api====>>>> $data");

      if (data["status"] == 1) {
          userId=data["data"]["user_id"];
        print("user_id = ${userId} order_id = ${data["data"]["order_id"]}");
        Future.delayed(Duration(microseconds: 500));
        emit(RazorpaySuccessState(razorpay_order_id:data["data"]["order_id"] ));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
    }

  }



Future<void> paymentVerification({PaymentSuccessResponse? paymentVerify,String? bpoint,Set<SeatModell>? selectedSeats,List<Passenger>? selectedPassenger}) async{

    try {

      var formData={
  "razorpay_order_id": paymentVerify!.orderId,
  "razorpay_payment_id": paymentVerify.paymentId,
  "razorpay_signature": paymentVerify.signature,
  "user_id": userId,
  "amount":int.parse(tripData.fare!)+50
};

      final response = await ApiRepository.postAPI(ApiConst.paymentVerification, formData,basurl2: ApiConst.baseUrl2);

    


        final data = response.data;

       print("Response from paymentVerification api ----------->>>> $data");

      if (data["status"] == 1) {

        confirmTentativeBooking();
        Future.delayed(Duration(milliseconds: 500));
        confirmBooking(tripData: tripData,bpoint: bpoint,orderId:paymentVerify.orderId,selectedSeats: selectedSeats,selectedPassenger: selectedPassenger );
        emit(BookingLoaded());
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }

    } catch (e) {
      print("Error in getTentativeBooking: $e");
    }

  }


  
Future<void> confirmBooking({Availabletrips? tripData,String? bpoint,Set<SeatModell>? selectedSeats,List<Passenger>? selectedPassenger,String? orderId}) async{

    try {

      var formData={
        "razorpay_order_id": orderId,
        "pnr": pnr,
        "routeid": tripData!.routeid,
        "tripid": tripData.tripid,
        "bpoint": bpoint,
        "noofseats": selectedSeats!.length,
        "mobileno": await Session().getPhoneNo(),
        "email": await Session().getEmail(),
        "totalfare": ( selectedSeats.length * int.parse(tripData.fare.toString())).toInt()+50,
        "bookedat": globals.selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "ticketid":"ticket_${tripData!.routeid}_${tripData.tripid}_${globals.dateForTicket}" ,//"ticket_5906_149424_20250804074906571",
          "passengerInfo": selectedPassenger!
              .map( (p) => p.toJson()..update('fare', (value) => (value ?? 0) + 50),)
              .toList(),
       
        "opid": "VGT"
      };

final response = await ApiRepository.postAPI(ApiConst.confirmBooking, formData,basurl2: ApiConst.baseUrl2);

// final response = await dio.post(ApiConst.paymentVerification, data: {
//         "razorpay_order_id": orderId,
//         "pnr": pnr,
//         "routeid": tripData.routeid,
//         "tripid": tripData.tripid,
//         "bpoint": bpoint,
//         "noofseats": selectedSeats.length,
//         "mobileno": "8305933803",
//         "email": "aadityagupta778@gmail.com",
//         "totalfare": ( selectedSeats.length * int.parse(tripData.fare.toString())).toInt()+50,
//         "bookedat": globals.selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         "seatInfo": {
//           "passengerInfo": selectedPassenger
//               .map((p) => p.toJson())
//               .toList()
//         },
//         "opid": "VGT"
//       });

        final data = response.data;

       print("Response from confirmbooking api ----------->>>> $data");

       return data;

    } catch (e) {
      print("Error in confirmTentativeBooking: $e");
    }

  }









  //   createOrder(int fare,String phoneNo,String email) async{

  //      emit(BookingLoading());
  //     try {
  //       final formData = {
  //   "amount": 1050,
  //   "phone": phoneNo,
  //   "email": email
  // };

  //       final response = await ApiRepository.postAPI(ApiConst.createOrder, formData,basurl2: ApiConst.baseUrl2);

  //       final data = response.data;

  //        print("Response from createorder api $data");

  //       // if (data["status"] != null && data["status"]["success"] == true) {
  //       //   await Session().setPnr(data["BookingInfo"]["PNR"]);
  //       //   emit(BookingLoaded());
  //       // } else {
  //       //   final message = data["status"]?["message"] ?? "Failed to load stations";
  //       //   emit(BookingFailure(error: message));
  //       // }
  //     } catch (e) {
  //       print("Error in getTentativeBooking: $e");
  //       emit(BookingFailure(error: "Something went wrong. Please try again."));
  //     }

  //   }
}
