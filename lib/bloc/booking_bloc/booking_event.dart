import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/seat_modell.dart';

abstract class BookingEvent {}


class OnContinueButtonClick extends BookingEvent{
  int? bpoint;
  int? noofseats;
  int? totalfare;
  BpDetails? selectedBoardingPointDetails;
  DpDetails? selectedDroppingPointDetails;
  List<Passenger>? selectedPassenger;
  String? opId;
  Set<SeatModell>? selectedSeats;
  OnContinueButtonClick({this.bpoint,this.noofseats,this.selectedPassenger,this.totalfare,
    this.selectedBoardingPointDetails, this.selectedDroppingPointDetails,this.opId,this.selectedSeats});
}

class OnPaymentVerification extends BookingEvent{
  PaymentSuccessResponse? response;
  OnPaymentVerification({this.response});
}

class ShowTicket extends BookingEvent{
  String? pnr;
  String? userName;
  Trips? tripData;
  String? dropingPoint;
  String? ticketId;
  ShowTicket({this.pnr,this.userName,this.tripData,this.dropingPoint,this.ticketId});
}

