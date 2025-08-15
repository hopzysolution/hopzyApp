import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';

abstract class BookingEvent {}


class OnContinueButtonClick extends BookingEvent{
  int? bpoint;
  int? noofseats;
  int? totalfare;
  List<Passenger>? selectedPassenger;
  OnContinueButtonClick({this.bpoint,this.noofseats,this.selectedPassenger,this.totalfare});
}

class OnPaymentVerification extends BookingEvent{
  PaymentSuccessResponse? response;
  OnPaymentVerification({this.response});
}

class ShowTicket extends BookingEvent{
  String? pnr;
  String? userName;
  Availabletrips? tripData;
  String? dropingPoint;
  ShowTicket({this.pnr,this.userName,this.tripData,this.dropingPoint});
}

