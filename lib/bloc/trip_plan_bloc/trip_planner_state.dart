// 3. States
import 'package:ridebooking/models/trip_plan_request.dart';

abstract class TripPlannerState {}

class TripPlannerInitial extends TripPlannerState {}

class TripPlannerLoading extends TripPlannerState {}

class TripPlannerSuccess extends TripPlannerState {
  final TripPlan tripPlan;
  final TripPlanRequest request;

  TripPlannerSuccess(this.tripPlan, this.request);
}

class TripPlannerError extends TripPlannerState {
  final String message;

  TripPlannerError(this.message);
}

class RecentSearchesLoaded extends TripPlannerState {
  final List<String> recentSearches;

  RecentSearchesLoaded(this.recentSearches);
}