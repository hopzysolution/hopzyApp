abstract class HomeScreenEvent {}

class SearchAvailableTripsEvent extends HomeScreenEvent {
  final String from;
  final String to;
  final String date;

  SearchAvailableTripsEvent({required this.from, required this.to, required this.date});
}