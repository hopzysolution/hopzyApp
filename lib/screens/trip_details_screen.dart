import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridebooking/commonWidgets/bus_receipt_widget.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/ticket_details_model.dart';
import 'package:ridebooking/screens/cancellation_refund_policy.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/route_generate.dart';

class TripDetailsScreen extends StatefulWidget {
  TicketDetails? ticketDetails; 
  Availabletrips? tripData;
  String? dropingPoint;
   TripDetailsScreen({super.key,this.ticketDetails,this.tripData,this.dropingPoint});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {

List<String> seatNumbers=[];

String? journeyDate="";

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  widget.ticketDetails!.seatDetails!.map((e){
      seatNumbers.add(e.seatName!);
    }).toList();

    // journeyDate="${DateTime.parse(widget.ticketDetails!.doj!).year}-${DateTime.parse(widget.ticketDetails!.doj!).month}-${DateTime.parse(widget.ticketDetails!.doj!).day}";

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: const Text('Ticket Details',
        style: TextStyle(
          color: AppColors.neutral50
        ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacementNamed(context, Routes.dashboard);
        }, icon: Icon(Icons.arrow_back,
        color: AppColors.neutral50,
        )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(42.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                BusReceiptWidget(
                phoneNumber: widget.ticketDetails!.custMobNo!, //"+91 9876543210",
                boardingTime: widget.ticketDetails!.pickupTime!,//"10:00 AM",
                droppingTime: widget.tripData!.arrtime! ,//widget.ticketDetails!.dropTime! ,//"02:00 PM",
                totalSeats: widget.ticketDetails!.seatDetails!.length.toString(),//"2",
                seatNumbers: seatNumbers.toString().replaceAll("[", "").replaceAll("]", ""),
                busType: widget.ticketDetails!.busType!,
                journeyDate: "${DateTime.parse(widget.ticketDetails!.doj!).year}-${DateTime.parse(widget.ticketDetails!.doj!).month}-${DateTime.parse(widget.ticketDetails!.doj!).day}" ,//"25/02/2025",
                busServiceName: widget.ticketDetails!.operatorName! ,//'Bus Service Name',
                route: '${widget.ticketDetails!.sourceCityId!} to ${widget.ticketDetails!.pickUpLocationAddress!}',
                boardingPoint: widget.ticketDetails!.pickupLocation!,
                droppingPoint: widget.dropingPoint! ,//widget.ticketDetails!.dropLocation!,
                // ... other parameters
                seatdetails: widget.ticketDetails!.seatDetails!,
                onHomePressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.dashboard),
                onDownloadPressed: () => {/* Download logic */},
                basicFare: (widget.ticketDetails!.bookingFee!- widget.ticketDetails!.bookingStax!).toDouble(),
                bookingtax: widget.ticketDetails!.bookingStax!.toDouble(),
                // rounding: -0.80,
                totalFare: widget.ticketDetails!.bookingFee!.toDouble(),
                isReceipt: true,
              ),
              const SizedBox(height: 15),
              CancellationRefundView(
                  cancellationPolicy: widget.ticketDetails!.cancellationPolicy!,
                  cancellationRefundPolicy: widget.ticketDetails!.cancellationRefundPolicy!,
              )
              
            ],
          )
        ),
      ),
    );
  }
}