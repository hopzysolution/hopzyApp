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
import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/session.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Availabletrips tripData;

  BookingBloc(this.tripData) : super(BookingInitial()) {
    on<OnContinueButtonClick>(_onContinueButtonClick);
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
        "mobileno": "8305933803",
        "email": "aadityagupta778@gmail.com",
        "totalfare": event.totalfare!+50,
        "bookedat": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "seatInfo": {
          "passengerInfo": event.selectedPassenger!
              .map((p) => p.toJson())
              .toList()
        },
        "opid": "VGT"
      };

      final response = await ApiRepository.postAPI(ApiConst.getTentativeBooking, formData);

      final data = response.data;

      if (data["status"] != null && data["status"]["success"] == true) {
       ApiClient().createOrder(event.totalfare!,"8305933803","aadityagupta778@gmail.com",event,emit);
        await Session().setPnr(data["BookingInfo"]["PNR"]);
        emit(BookingLoaded(fare:event.totalfare!));
        
      } else {
        final message = data["status"]?["message"] ?? "Failed to load stations";
        emit(BookingFailure(error: message));
      }
    } catch (e) {
      print("Error in getTentativeBooking: $e");
      emit(BookingFailure(error: "Something went wrong. Please try again."));
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
