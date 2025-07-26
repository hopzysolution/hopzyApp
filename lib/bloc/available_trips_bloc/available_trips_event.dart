abstract class AvailableTripsEvent {}

class AvailableTripsFetchEvent extends AvailableTripsEvent {
  final String? src;
  final String? dst;
  final String? date;

  AvailableTripsFetchEvent({this.src, this.dst, this.date});
}