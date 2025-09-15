import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/globels.dart' as globals;

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  List<AllAvailabletrips>? allAvailabletrips;
  List<Availabletrips> allTrips = [];
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<SearchAvailableTripsEvent>((event, emit) async {
      emit(HomeScreenLoading());
      // try {
    

      // var response = await ApiRepository.postAPI(
      //   ApiConst.getAllAvailableTripsOnADay,
      //   formData,
      // );

      getAvailableTrips(event.from,event.to,globals.selectedDate);

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
    getAllAvailableTripsOnADay();
  }

  List<Availabletrips> availableaatripsList = [];


  Future<void> getAvailableTrips(
  String from,
  String to,
  String selectedDate,
) async {
  emit(HomeScreenLoading());

  try {
    // Prepare futures for all operator calls
    final futures = globals.operatorListModel.operatorlist!.map((opid) {
      final formData = {
        "src": from,
        "dst": to,
        "tripdate": selectedDate,
        "opid": "VGT",//opid.code,
      };

      return ApiRepository.postAPI(ApiConst.getAvailableTrips, formData)
          .catchError((e) {
        print("Error for operator $opid: $e");
        return null; // avoid breaking the loop
      });
    }).toList();

    // Run all requests in parallel
    final responses = await Future.wait(futures);

    // Combine results
    List<Availabletrips> allTrips = [];
    for (var response in responses) {
      if (response == null) continue;
      final data = response.data;
      if (data["status"]?["success"] == true) {
        final parsed = GetAvailableTrips.fromJson(data);
        allTrips.addAll(parsed.availabletrips ?? []);
      }
    }

    if (allTrips.isNotEmpty) {
      Session().saveTripsToSession(allTrips);
      emit(AllTripSuccessState(allTrips: allTrips));
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





void getAllAvailableTripsOnADay() async {
  emit(HomeScreenLoading());

  print(
    "Date Format ======>>${DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now())}"
    "=========>>>>>${globals.dateForTicket}",
  );

  try {
    // Clear previous trips before fetching new ones
    allAvailabletrips = [];

    final List<Future> futures = [];

    for (var operator in globals.operatorListModel.operatorlist ?? []) {
      if (operator.code != null && operator.code!.contains("VT")) {
        var formData = {
          "tripdate": DateFormat('yyyy-MM-dd').format(
            DateTime.now().add(const Duration(days: 1)),
          ),
          "opid": "VGT",//operator.code,
        };

        // Add async task to list
        futures.add(ApiRepository.postAPI(
          ApiConst.getAllAvailableTripsOnADay,
          formData,
        ));
      }
    }

    // Run all requests in parallel
    final responses = await Future.wait(futures);

    for (var response in responses) {
      var data = response.data;
      if (data["status"] != null && data["status"]["success"] == true) {
        AllTripDataModel allTripDataModel = AllTripDataModel.fromJson(data);
        allAvailabletrips!.addAll(allTripDataModel.availabletrips ?? []);
      }
    }

    if (allAvailabletrips!.isNotEmpty) {
      print("allAvailabletrips --------->>>>${allAvailabletrips!.length}");
      emit(HomeScreenLoaded(allAvailabletrips: allAvailabletrips));
    } else {
      emit(HomeScreenFailure(error: "No trips found"));
    }
  } catch (e) {
    print("Error in getAllAvailableTripsOnADay: $e");
    emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
  }
}


}
