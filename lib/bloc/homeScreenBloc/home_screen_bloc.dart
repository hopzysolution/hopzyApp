import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/repository/ApiResponse.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent,HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenEvent>((event, emit) {
      // Handle home screen events here
      // For example, you can add logic to fetch data or update the UI state
    });
    getAllStations();
  }


  void getAllStations() async{
    // Logic to fetch all stations
    // This could involve making an API call and then emitting a new state with the fetched data
    emit(HomeScreenLoading());
    // Simulate a network call
    ApiResponse response = await ApiRepository.getAPI(ApiConst.getStations);
    if (response.status.success) {
      // Assuming the response contains a list of stations
      StationModel stations = response.data['stationDetails'];
      print("object of stations is --->>> : ${stations.toJson()}");
      emit(HomeScreenLoaded(stations: stations));
    } else {
      emit(HomeScreenFailure(error: response.status.message));
    }
  }
}