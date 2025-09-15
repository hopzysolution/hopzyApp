import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/booking_details.dart';
import 'package:ridebooking/models/create_order_data_model.dart' hide Data;
import 'package:ridebooking/models/ticket_details_model.dart';

abstract class BookingState {}



class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState {
  // final List<StationDetails>? stations;
int? fare;
  BookingLoaded({this.fare});
}
class BookingFailure extends BookingState {
  final String error;

  BookingFailure({required this.error});
}

class BookingSuccess extends BookingState {
  final String success;

  BookingSuccess({required this.success});
}


class RazorpaySuccessState extends BookingState{
  String? razorpay_order_id;
  RazorpaySuccessState({this.razorpay_order_id});
}

class PayUSuccessState extends BookingState{
  CreateOrderDataModel? createOrderDataModel;
  PayUSuccessState({this.createOrderDataModel});
}

class ConfirmBooking extends BookingState{
  String? pnr;
  String? userName;
  String? ticketId;
  ConfirmBooking(this.userName,this.pnr,this.ticketId);
}

class ShowTicketState extends BookingState{
TicketDetails? ticketDetails;
Availabletrips? tripData;
String? dropingPoint;
Data? ticketData; 
ShowTicketState(this.ticketDetails,this.tripData,this.dropingPoint,this.ticketData);
}



// class AllTripSuccessState extends BookingState {

// final List<Availabletrips>? allTrips;

//   AllTripSuccessState({this.allTrips});
// }