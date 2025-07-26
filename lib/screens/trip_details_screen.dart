import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridebooking/commonWidgets/bus_receipt_widget.dart';
import 'package:ridebooking/utils/app_colors.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(42.0),
          child: Column(
            children: [
                BusReceiptWidget(
                phoneNumber: "+91 9876543210",
                boardingTime: "10:00 AM",
                droppingTime: "02:00 PM",
                totalSeats: "2",
                seatNumbers: "15,16",
                busType: "Ordinary",
                journeyDate: "25/02/2025",
                busServiceName: 'Bus Service Name',
                route: 'Pandharpur to Mumbai Central via Swargate',
                boardingPoint: 'Swargate',
                droppingPoint: 'Mumbai Central',
                // ... other parameters
                passengers: [
                  PassengerInfo(name: 'John Doe', age: 30, gender: 'M'),
                ],
                onHomePressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                onDownloadPressed: () => {/* Download logic */},
                basicFare: 562.80,
                reservation: 2.00,
                rounding: -0.80,
                totalFare: 574.00,
                isReceipt: true,
              ),
              const SizedBox(height: 80),
                BusReceiptWidget(
                phoneNumber: "+91 9876543210",
                boardingTime: "10:00 AM",
                droppingTime: "02:00 PM",
                totalSeats: "2",
                seatNumbers: "15,16",
                busType: "Ordinary",
                journeyDate: "25/02/2025",
                busServiceName: 'Bus Service Name',
                route: 'Pandharpur to Mumbai Central via Swargate',
                boardingPoint: 'Swargate',
                droppingPoint: 'Mumbai Central',
                // ... other parameters
                passengers: [
                  PassengerInfo(name: 'John Doe', age: 30, gender: 'M'),
                ],
                onHomePressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                onDownloadPressed: () => {/* Download logic */},
                basicFare: 562.80,
                reservation: 2.00,
                rounding: -0.80,
                totalFare: 574.00,
                isReceipt: false,
              ),
            ],
          )
        ),
      ),
    );
  }
}