// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ridebooking/commonWidgets/bus_receipt_widget.dart';
// import 'package:ridebooking/commonWidgets/ticket_pdf_generator.dart';
// import 'package:ridebooking/models/available_trip_data.dart' hide Data;
// import 'package:ridebooking/models/booking_details.dart';
// import 'package:ridebooking/models/ticket_details_model.dart';
// import 'package:ridebooking/screens/cancellation_refund_policy.dart';
// import 'package:ridebooking/utils/app_colors.dart';
// import 'package:ridebooking/utils/route_generate.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// class TripDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic>? ticketDetails;
//   // Trips? tripData;
//   // String? dropingPoint;
//   // Data? ticketData;
//
//   TripDetailsScreen({
//     super.key,
//     this.ticketDetails,
//     // this.tripData,
//     // this.dropingPoint,
//     // this.ticketData,
//   });
//
//   @override
//   State<TripDetailsScreen> createState() => _TripDetailsScreenState();
// }
//
// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   List<String> seatNumbers = [];
//   String? journeyDate = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   void _initializeData() {
//     try {
//       // Extract seat numbers
//       if (widget.ticketDetails?.seatDetails != null) {
//         seatNumbers = widget.ticketDetails!.seatDetails!
//             .map((e) => e.seatName ?? "")
//             .where((name) => name.isNotEmpty)
//             .toList();
//       }
//
//       // Format journey date
//       if (widget.ticketDetails?.doj != null) {
//         try {
//           final date = DateTime.parse(widget.ticketDetails!.doj!);
//           journeyDate = "${date.year}-${date.month}-${date.day}";
//         } catch (e) {
//           print("Error parsing date: $e");
//           journeyDate = widget.ticketDetails!.doj;
//         }
//       }
//       print("this is on trip page${jsonEncode(widget.ticketDetails)}");
//
//       print("✅ Trip Details initialized:");
//       print("   Seats: $seatNumbers");
//       print("   Journey Date: $journeyDate");
//       print("   PNR: ${widget.ticketDetails?.pnr}");
//     } catch (e) {
//       print("❌ Error initializing trip details: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Handle null ticketDetails gracefully
//     if (widget.ticketDetails == null) {
//       return Scaffold(
//         backgroundColor: AppColors.neutral100,
//         appBar: AppBar(
//           title: const Text(
//             'Ticket Details',
//             style: TextStyle(color: AppColors.neutral50),
//           ),
//           centerTitle: false,
//           backgroundColor: AppColors.primaryBlue,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 64, color: Colors.red),
//               SizedBox(height: 16),
//               Text(
//                 'Failed to load ticket details',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 },
//                 child: Text('Go to Home'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: AppColors.neutral100,
//       appBar: AppBar(
//         title: const Text(
//           'Ticket Details',
//           style: TextStyle(color: AppColors.neutral50),
//         ),
//         centerTitle: false,
//         backgroundColor: AppColors.primaryBlue,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, Routes.dashboard);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: AppColors.neutral50,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         physics: AlwaysScrollableScrollPhysics(),
//         child: Container(
//           padding: const EdgeInsets.all(42.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BusReceiptWidget(
//                 phoneNumber: widget.ticketDetails!.custMobNo ?? "+91 XXXXXXXXXX",
//                 boardingTime: widget.ticketDetails!.pickupTime ?? "00:00 AM",
//                 droppingTime: widget.ticketDetails?.de != null
//                     ? DateFormat('hh:mm a').format(
//                   DateTime.parse(widget.tripData!.arrtime!),
//                 )
//                     : "00:00 PM",
//                 totalSeats: widget.ticketDetails!.seatDetails?.length.toString() ?? "0",
//                 seatNumbers: seatNumbers.toString().replaceAll("[", "").replaceAll("]", ""),
//                 busType: widget.ticketDetails!.busType ?? "N/A",
//                 journeyDate: journeyDate ?? "N/A",
//                 busServiceName: widget.ticketDetails!.operatorName ?? "N/A",
//                 route: '${widget.ticketDetails!.sourceCityId ?? "N/A"} to ${widget.ticketDetails!.pickUpLocationAddress ?? "N/A"}',
//                 boardingPoint: widget.ticketDetails!.pickupLocation ?? "N/A",
//                 droppingPoint: widget.dropingPoint?.split("-").first ??
//                     widget.ticketDetails!.dropLocation ?? "N/A",
//                 seatdetails: widget.ticketDetails!.seatDetails ?? [],
//                 onHomePressed: () =>
//                     Navigator.pushReplacementNamed(context, Routes.dashboard),
//                 onDownloadPressed: () {
//                   if (widget.ticketData != null) {
//                     TicketPdfGenerator().downloadPdf(
//                       context,
//                       widget.ticketData!,
//                       widget.ticketDetails!,
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Unable to download ticket')),
//                     );
//                   }
//                 },
//                 basicFare: ((widget.ticketDetails!.bookingFee ?? 0) -
//                     (widget.ticketDetails!.bookingStax ?? 0))
//                     .toDouble(),
//                 bookingtax: (widget.ticketDetails!.bookingStax ?? 0).toDouble(),
//                 totalFare: (widget.ticketDetails!.bookingFee ?? 0).toDouble(),
//                 isReceipt: true,
//               ),
//               Text("This is trip details page"),
//
//               const SizedBox(height: 15),
//               if (widget.ticketDetails!.cancellationPolicy != null &&
//                   widget.ticketDetails!.cancellationRefundPolicy != null)
//                 CancellationRefundView(
//                   cancellationPolicy: widget.ticketDetails!.cancellationPolicy!,
//                   cancellationRefundPolicy:
//                   widget.ticketDetails!.cancellationRefundPolicy!,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/commonWidgets/bus_receipt_widget.dart';
import 'package:ridebooking/commonWidgets/ticket_pdf_generator.dart';
import 'package:ridebooking/models/booking_details.dart';
import 'package:ridebooking/models/ticket_details_model.dart';
import 'package:ridebooking/screens/cancellation_refund_policy.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/route_generate.dart';

class TripDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? ticketDetails;

  const TripDetailsScreen({
    super.key,
    this.ticketDetails,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<String> seatNumbers = [];
  String? journeyDate = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    try {
      final passengers = widget.ticketDetails?['passengers'] as List<dynamic>? ?? [];
      seatNumbers = passengers.map((e) => e['seatNo'].toString()).toList();

      final dateString = widget.ticketDetails?['journeyDate'];
      if (dateString != null) {
        try {
          final date = DateTime.parse(dateString);
          journeyDate = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          journeyDate = dateString;
        }
      }

      print("✅ Trip Details initialized: ${jsonEncode(widget.ticketDetails)}");
    } catch (e) {
      print("❌ Error initializing trip details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticketDetails ?? {};
    final boardingPoint = ticket['boarding_point'] ?? {};
    final droppingPoint = ticket['dropping_point'] ?? {};

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: const Text(
          'Ticket Details',
          style: TextStyle(color: AppColors.neutral50),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.dashboard);
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral50),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(42.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === Bus Receipt Widget ===
              BusReceiptWidget(
                phoneNumber: ticket['supportPhone'] ?? "+91 XXXXXXXXXX",
                boardingDate: (boardingPoint['time'] ?? "YYYY-MM-DD ").split(' ')[0] ?? "00:00 AM",
                boardingTime: (boardingPoint['time'] ?? "HH:MM:SS").split(' ')[1] ?? "00:00 PM",
                totalSeats: seatNumbers.length.toString(),
                seatNumbers:
                seatNumbers.isNotEmpty ? seatNumbers.join(", ") : "N/A",
                busType: ticket['bustype'] ?? "N/A",
                journeyDate: journeyDate ?? "N/A",
                busServiceName: ticket['operatorName'] ?? "Vishal Tourist",
                route:
                "${ticket['from'] ?? 'N/A'} → ${ticket['to'] ?? 'N/A'}",
                boardingPoint:
                boardingPoint['venue'] ?? boardingPoint['name'] ?? "N/A",
                droppingPoint:
                droppingPoint['venue'] ?? droppingPoint['name'] ?? "N/A",
                seatdetails: (ticket['passengers'] as List<dynamic>? ?? [])
                    .map((p) => Map<String, dynamic>.from(p as Map))
                    .toList(),

                onHomePressed: () {
                  Navigator.pushReplacementNamed(context, Routes.dashboard);
                },
                onDownloadPressed: () async {
                  try {
                    print("Tryign to download ticket");
                    await TicketPdfGenerator().downloadPdf(
                      context,
                      ticket
                    );
                  } catch (e,stackTrace) {
                    print(stackTrace);
                    ScaffoldMessenger.of(context).showSnackBar(

                      const SnackBar(content: Text('Unable to download ticket')),
                    );
                  }
                },
                basicFare: (ticket['totalfare'] ?? 0).toDouble(),
                bookingtax: (ticket['gst'] ?? 0).toDouble(),
                totalFare: (ticket['totalfare'] ?? 0).toDouble(),
                isReceipt: true,
              ),

              const SizedBox(height: 20),

              // === Cancellation Policy Section ===
              // if (ticket['cancellationpolicy'] != null &&
              //     ticket['cancellationpolicy']['terms'] != null)
              //   CancellationRefundView(
              //     cancellationPolicy: ticket['cancellationpolicy']['terms'],
              //     cancellationRefundPolicy:
              //     ticket['cancellationpolicy']['terms'],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
