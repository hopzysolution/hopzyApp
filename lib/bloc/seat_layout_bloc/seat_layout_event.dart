abstract class SeatLayoutEvent {}

class SeatLayoutFetchEvent extends SeatLayoutEvent {
  final String? srcOrder;
  final String? dstOrder;
  final String? routeId;
  final String? tripId;

  SeatLayoutFetchEvent({this.srcOrder, this.dstOrder, this.routeId, this.tripId});
}