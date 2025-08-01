import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';

class BookingBloc extends Bloc<BookingEvent,BookingState> {
  Availabletrips tripData;

BookingBloc(this.tripData) : super(BookingInitial()) {

  on<OnContinueButtonClick>((event,emit){
    getTentativeBooking(
      event.bpoint!,event.noofseats!,event.totalfare!,event.selectedPassenger!
    );

  });


}

  getTentativeBooking(int bpoint,int noofseats,int totalfare,List<Passenger> selectedPassenger) async{

     emit(BookingLoading());

  try {

var formData = {
  "routeid": tripData.routeid,
  "tripid": tripData.tripid,
  "bpoint": 522446,
  "noofseats": 1,
  "mobileno": "8305933803",
  "email": "aadityagupta778@gmail.com",
  "totalfare": 1050,
  "bookedat": DateFormat('yyyy-MM-dd').format(DateTime.now()),
  "seatInfo": {
  "passengerInfo": selectedPassenger
  },
  "opid": "VGT"
};

    var response = await ApiRepository.postAPI(ApiConst.getTentativeBooking,formData);

    final data = response.data; // ✅ Extract actual response map

    if (data["status"] != null && data["status"]["success"] == true) {

        await Session().setPnr(data["BookingInfo"]["PNR"]);

        print("Tentative Booking done----------->${data["BookingInfo"]["PNR"]}");
      
      emit(BookingLoaded());
    } else {
      final message = data["status"]?["message"] ?? "Failed to load stations";
      emit(BookingFailure(error: message));
    }
  } catch (e) {
    print("Error in getAllStations: $e");
    emit(BookingFailure(error: "Something went wrong. Please try again."));
  }
  }



}