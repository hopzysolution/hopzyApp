// States
import 'package:ridebooking/models/operator_list_model.dart';

abstract class AllStationState {}

class AllStationInitial extends AllStationState {}

class AllStationLoading extends AllStationState {}

class AllStationLoaded extends AllStationState {
  final List<City> cities;
  final bool hasMore;
  final int page;

  AllStationLoaded({
    required this.cities,
    required this.hasMore,
    required this.page,
  });
}

class AllStationError extends AllStationState {
  final String message;

  AllStationError({required this.message});
}