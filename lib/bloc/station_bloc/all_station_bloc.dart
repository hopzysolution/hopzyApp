// Bloc
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/station_bloc/all_station_event.dart';
import 'package:ridebooking/bloc/station_bloc/all_station_state.dart';
import 'package:ridebooking/models/operator_list_model.dart';

class AllStationBloc extends Bloc<AllStationEvent, AllStationState> {
  final Dio _dio = Dio();
  final String baseUrl = 'https://stagingapi.hopzy.in/api/public/stations';

  AllStationBloc() : super(AllStationInitial()) {
    on<FetchStationsEvent>(_onFetchStations);
    on<ClearStationsEvent>(_onClearStations);
  }

  Future<void> _onFetchStations(
    FetchStationsEvent event,
    Emitter<AllStationState> emit,
  ) async {
    if (event.searchQuery.isEmpty) {
      emit(AllStationInitial());
      return;
    }

    emit(AllStationLoading());

    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'search': event.searchQuery,
          'type': event.type,
          'page': 1,
          'limit': 10,
        },
      );

      if (response.statusCode == 200) {
        final stationListModel = StationListModel.fromJson(response.data);
        
        if (stationListModel.data != null && 
            stationListModel.data!.cities != null) {
          emit(AllStationLoaded(
            cities: stationListModel.data!.cities!,
            hasMore: stationListModel.data!.hasMore ?? false,
            page: stationListModel.data!.page ?? 1,
          ));
        } else {
          emit(AllStationLoaded(
            cities: [],
            hasMore: false,
            page: 1,
          ));
        }
      } else {
        emit(AllStationError(message: 'Failed to load stations'));
      }
    } on DioException catch (e) {
      emit(AllStationError(
        message: e.response?.data['message'] ?? 'Network error occurred',
      ));
    } catch (e) {
      emit(AllStationError(message: 'An unexpected error occurred'));
    }
  }

  void _onClearStations(
    ClearStationsEvent event,
    Emitter<AllStationState> emit,
  ) {
    emit(AllStationInitial());
  }

  @override
  Future<void> close() {
    _dio.close();
    return super.close();
  }
}