// 5. BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/teip_planner_event.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_repository.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_state.dart';

class TripPlannerBloc extends Bloc<TripPlannerEvent, TripPlannerState> {
  final TripPlannerRepository repository;

  TripPlannerBloc({required this.repository}) : super(TripPlannerInitial()) {
    on<GenerateTripPlan>(_onGenerateTripPlan);
    on<ResetTripPlanner>(_onResetTripPlanner);
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<SaveRecentSearch>(_onSaveRecentSearch);
  }

  Future<void> _onGenerateTripPlan(
    GenerateTripPlan event,
    Emitter<TripPlannerState> emit,
  ) async {
    emit(TripPlannerLoading());
    try {
      // Save recent search
      await repository.saveRecentSearch(event.request.destination);
      
      final tripPlan = await repository.generateTripPlan(event.request);
      emit(TripPlannerSuccess(tripPlan, event.request));
    } catch (e) {
      emit(TripPlannerError(e.toString()));
    }
  }

  void _onResetTripPlanner(
    ResetTripPlanner event,
    Emitter<TripPlannerState> emit,
  ) {
    emit(TripPlannerInitial());
  }

  Future<void> _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<TripPlannerState> emit,
  ) async {
    try {
      final searches = await repository.getRecentSearches();
      emit(RecentSearchesLoaded(searches));
    } catch (e) {
      // If loading recent searches fails, just emit empty list
      emit(RecentSearchesLoaded([]));
    }
  }

  Future<void> _onSaveRecentSearch(
    SaveRecentSearch event,
    Emitter<TripPlannerState> emit,
  ) async {
    await repository.saveRecentSearch(event.destination);
  }
}