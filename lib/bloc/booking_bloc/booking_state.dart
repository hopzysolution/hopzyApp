import 'package:ridebooking/models/available_trip_data.dart' hide Data;
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

class RazorpaySuccessState extends BookingState {
  String? razorpay_order_id;
  RazorpaySuccessState({this.razorpay_order_id});
}

class PayUSuccessState extends BookingState {
  CreateOrderDataModel? createOrderDataModel;
  PayUSuccessState({this.createOrderDataModel});
}
//old
// class ConfirmBooking extends BookingState{
//   String? pnr;
//   String? userName;
//   String? ticketId;
//   ConfirmBooking(this.userName,this.pnr,this.ticketId);
// }

//new
class ConfirmBooking extends BookingState {
  final String? pnr;
  final String? userName;
  final String? ticketId;
  final Trips? tripData;
  final String? dropingPoint;
  final dynamic ticketData; // full booking API response

  ConfirmBooking(
    this.userName,
    this.pnr,
    this.ticketId, {
    this.tripData,
    this.dropingPoint,
    this.ticketData,
  });
}

// class ShowTicketState extends BookingState {
//   TicketDetails? ticketDetails;
//   Trips? tripData;
//   String? dropingPoint;
//   Data? ticketData;
//   ShowTicketState(
//     this.ticketDetails,
//     this.tripData,
//     this.dropingPoint,
//     this.ticketData,
//   );
// }
//new
class ShowTicketState extends BookingState {
  // final TicketDetails? ticketDetails;  // The ticket details object
  // final Trips? tripData;               // The trip data
  // final String? dropingPoint;          // Dropping point address
  // final dynamic ticketData;            // Raw API response (Data object)
  final Map<String, dynamic> ticketDetails;

  ShowTicketState(
      this.ticketDetails,
      // this.tripData,
      // this.dropingPoint,
      // this.ticketData,
      );
}
// class AllTripSuccessState extends BookingState {

// final List<Availabletrips>? allTrips;

//   AllTripSuccessState({this.allTrips});
// }
