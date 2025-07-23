import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/repository/ApiResponse.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent,HomeScreenState> {
List<StationDetails>? stations;
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenEvent>((event, emit) {
      // Handle home screen events here
      // For example, you can add logic to fetch data or update the UI state
    });
    getAllStations();
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