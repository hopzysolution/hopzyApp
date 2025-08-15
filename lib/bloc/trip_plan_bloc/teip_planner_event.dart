// 2. Events
import 'package:ridebooking/models/trip_plan_request.dart';

abstract class TripPlannerEvent {}

class GenerateTripPlan extends TripPlannerEvent {
  final TripPlanRequest request;

  GenerateTripPlan(this.request);
}

class ResetTripPlanner extends TripPlannerEvent {}

class LoadRecentSearches extends TripPlannerEvent {}

class SaveRecentSearch extends TripPlannerEvent {
  final String destination;

  SaveRecentSearch(this.destination);
}