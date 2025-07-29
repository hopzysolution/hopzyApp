abstract class SeatLayoutEvent {}

class SeatLayoutFetchEvent extends SeatLayoutEvent {
  final String? srcOrder;
  final String? dstOrder;
  final String? routeId;
  final String? tripId;
  final String? opid;

  SeatLayoutFetchEvent({this.srcOrder, this.dstOrder, this.routeId, this.tripId,this.opid});
}