import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/models/all_trip_data_model.dart' hide Availabletrips;
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/repository/ApiResponse.dart';
import 'package:ridebooking/utils/session.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent,HomeScreenState> {
List<StationDetails>? stations;
List<Availabletrips> allTrips = [];
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<SearchAvailableTripsEvent>((event, emit) async{
      emit(HomeScreenLoading());

  try {

    var formData = {
      "src": event.from,
    "dst": event.to,
    "tripdate": event.date,
    "opid": "VGT"
    };



    var response = await ApiRepository.postAPI(ApiConst.getAllAvailableTrips, formData);

    getAvailableTrips(formData);

    final data = response.data; // ✅ Extract actual response map

    if (data["status"] != null) {
    //   AllTripDataModel allTripDataModel = AllTripDataModel.fromJson(data);
    //   allTrips = allTripDataModel.availabletrips!;
    //  Session().saveTripsToSession(allTrips.cast<Availabletrips>());
    //   emit(AllTripSuccessState(allTrips: allTrips));
    } else {
      final message = data["status"]?["message"] ?? "Failed to load stations";
      emit(HomeScreenFailure(error: message));
    }
  } catch (e) {
    print("Error in getAllStations: $e");
    emit(HomeScreenFailure(error: "Something went wrong in api. Please try again."));
  }
    });
    getAllStations();
  }

  List<Availabletrips> availableaatripsList=[];

  void getAvailableTrips(var formData) async {
    emit(HomeScreenLoading());

    try {
      var response = await ApiRepository.postAPI(ApiConst.getAvailableTrips,formData);

      final data = response.data; // ✅ Extract actual response map

      if (data["status"] != null && data["status"]["success"] == true) {
        GetAvailableTrips getAvailableTrips = GetAvailableTrips.fromJson(data);
        availableaatripsList = getAvailableTrips.availabletrips!;
        Session().saveTripsToSession(availableaatripsList);
        emit(AllTripSuccessState(allTrips: availableaatripsList));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load trips";
        emit(HomeScreenFailure(error: message));
      }
    } catch (e) {
      print("Error in getAvailableTrips: $e");
      emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
    }
  }


  void getAllStations() async {
  emit(HomeScreenLoading());

  try {
    var response = await ApiRepository.getAPI(ApiConst.getStations);

    final data = response.data; // ✅ Extract actual response map

    if (data["status"] != null && data["status"]["success"] == true) {
      StationModel stationModel = StationModel.fromJson(data);
      stations = stationModel.stationDetails;
      emit(HomeScreenLoaded(stations: stations));
    } else {
      final message = data["status"]?["message"] ?? "Failed to load stations";
      emit(HomeScreenFailure(error: message));
    }
  } catch (e) {
    print("Error in getAllStations: $e");
    emit(HomeScreenFailure(error: "Something went wrong. Please try again."));
  }
}

}