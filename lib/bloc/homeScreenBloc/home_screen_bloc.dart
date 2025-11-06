import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/operator_list_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  List<AllAvailabletrips>? allAvailabletrips;
  List<Trips> allTrips = [];
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<SearchAvailableTripsEvent>((event, emit) async {
      emit(HomeScreenLoading());
      // try {
    

      // var response = await ApiRepository.postAPI(
      //   ApiConst.getAllAvailableTripsOnADay,
      //   formData,
      // );

      getAvailableTrips(
        event.src.cityIds!.whereType<String>().toList(),
        event.dst.cityIds!.whereType<String>().toList(),
        globals.selectedDate,
      );

      // final data = response.data; // ✅ Extract actual response map

      // if (data["status"] != null) {
      //   //   AllTripDataModel allTripDataModel = AllTripDataModel.fromJson(data);
      //   //   allTrips = allTripDataModel.availabletrips!;
      //   //  Session().saveTripsToSession(allTrips.cast<Availabletrips>());
      //   //   emit(AllTripSuccessState(allTrips: allTrips));
      // } else {
      //   final message =
      //       data["status"]?["message"] ?? "Failed to load stations";
      //   emit(HomeScreenFailure(error: message));
      // }
      // } catch (e) {
      //   print("Error in getAllStations: $e");
      //   emit(
      //     HomeScreenFailure(
      //       error: "Something went wrong in api. Please try again.",
      //     ),
      //   );
      // }
    });
    getStations();
  }

  List<Trips> availableaatripsList = [];

  StationListModel? stationListModel;

  Future<void> getAvailableTrips(
  List<String> from,
  List<String> to,
  String selectedDate,
) async {
  emit(HomeScreenLoading());

  try {
    // Prepare futures for all operator calls
    print("Searching hhh from -->${from}");
    print("Searching hhh from -->${to}");
    allTrips.clear(); //
      final formData = {
        "src": from,
        "dst": to,
        "tripdate": selectedDate,
        "limit":200,
        "page":1
      };

      // print("Response from getAvailableTrips: ${formData}");

      print("test for typecast---------->>>>0");


      final response = await ApiRepository.postAPI(ApiConst.getAvailableTrips, formData, basurl2: ApiConst.baseUrl2);
          
        print("test for typecast---------->>>>1");
      debugPrint("Response from getAvailableTrips: ${response.toString()}");

   
      final data = response.data;
        print("test for typecast---------->>>>2");
        final parsed = Availabletripdata.fromJson(data);
        print("test for typecast---------->>>>3");
        allTrips.addAll(parsed.data!.trips!);
        print("test for typecast---------->>>>4${allTrips.first.routeid}");
      

    if (allTrips.isNotEmpty) {
      print("test for typecast---------->>>>5");
      // Session().saveTripsToSession(allTrips);
      emit(AllTripSuccessState(allTrips: allTrips));
      print("test for typecast---------->>>>6");
    } else {
      emit(HomeScreenFailure(error: "No trips found"));
    }
  } catch (e) {
    print("Error in getAvailableTripsForAll: $e");
    emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
  }
}


  // Future<void> getAvailableTrips(String from,String to,String selectedDate) async {
  //   (HomeScreenLoading());

  //   try {

      

  //       var formData = {
  //       "src": from,
  //       "dst": to,
  //       "tripdate": selectedDate, //event.date,
  //       "opid": "VGT",
  //     };



  //     var response = await ApiRepository.postAPI(
  //       ApiConst.getAvailableTrips,
  //       formData,
  //     );

  //     final data = response.data; // ✅ Extract actual response map

  //     if (data["status"] != null && data["status"]["success"] == true) {
  //       GetAvailableTrips getAvailableTrips = GetAvailableTrips.fromJson(data);
  //       availableaatripsList = getAvailableTrips.availabletrips!;
  //       Session().saveTripsToSession(availableaatripsList);
  //       emit(AllTripSuccessState(allTrips: availableaatripsList));
  //     } else {
  //       final message = data["status"]?["message"] ?? "Failed to load trips";
  //       emit(HomeScreenFailure(error: message));
  //     }
  //   } catch (e) {
  //     print("Error in getAvailableTrips: $e");
  //     emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
  //   }
  // }




//     getAllAvailableTripsOnADay() async{


// var response = await ApiRepository.getAPI(
//         "api/public/stations", //?page=1&limit=10",
//         basurl2: ApiConst.baseUrl2,
//       );
//       final data = response.data;
//       print("------------------get user booking------data)-${data}-");

// if (response.statusCode == 200) {

//  stationListModel = StationListModel.fromJson(response.data);
//  globals.stationListModel = stationListModel!;
// //  emit(Spla)

//   debugPrint("Data to see -------------->>>>${stationListModel!.data!.dstCount}");
// }
// else {
//   print(response.statusMessage);
// }

//   }





void getStations() async {
  emit(HomeScreenLoading());

  print(
    "Date Format ======>>${DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now())}"
    "=========>>>>>${globals.dateForTicket}",
  );

  try {
    // Clear previous trips before fetching new ones
    allAvailabletrips = [];


   

    // Run all requests in parallel
    final responses = await ApiRepository.getAPI(
        "api/public/stations?search=chenn&type=dst&page=1&limit=10", //?page=1&limit=10",
        basurl2: ApiConst.baseUrl2,
      );
     
      stationListModel = StationListModel.fromJson(responses.data);
 globals.stationListModel = stationListModel!;

    if (stationListModel != null && stationListModel!.data != null) {
      emit(HomeScreenLoaded (stationListModel: stationListModel!.data!.cities));
    } else {
      emit(HomeScreenFailure(error: "No stations found"));
    }
  } catch (e) {
    print("Error in getAllAvailableTripsOnADay: $e");
    emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
  }
}


}
