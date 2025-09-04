import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:ridebooking/models/booking_details.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/ticket_details_model.dart';

class TicketPdfGenerator {
  pw.ImageProvider? logoImage;
  Future<void> downloadPdf(
  BuildContext context,
  Data ticketData,
  TicketDetails ticketDetails,
) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    // Android 10 and below → request storage permission
    if (androidInfo.version.sdkInt <= 29) {
      if (!await Permission.storage.request().isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Storage permission denied")),
        );
        return;
      }
    }
    // Android 11+ → no permission needed

    // Load logo and generate PDF
    logoImage = await loadAssetImage(
      "assets/images/Hopzy primary black & blue Pin.png",
    );
    await _generateAndSavePdf(context, ticketData, ticketDetails);
  } else {
    // iOS / Desktop → no permission needed
    logoImage = await loadAssetImage(
      "assets/images/Hopzy primary black & blue Pin.png",
    );
    await _generateAndSavePdf(context, ticketData, ticketDetails);
  }
}



// Helper: check permission based on Android version
Future<bool> _hasStoragePermission() async {
  if (!Platform.isAndroid) return true;

  final androidInfo = await DeviceInfoPlugin().androidInfo;

  if (androidInfo.version.sdkInt <= 29) {
    // Android 10 and below → need legacy storage permission
    return await Permission.storage.request().isGranted;
  }

  // Android 11+ → MediaStore handles access, no permission needed
  return true;
}




// helper: write bytes to temp file
Future<String> _writePdfToTemp(Uint8List bytes, String fileName) async {
  final tempDir = await getTemporaryDirectory();
  final tempFile = File("${tempDir.path}/$fileName");
  await tempFile.writeAsBytes(bytes);
  return tempFile.path;
}

Future<void> _generateAndSavePdf(
    BuildContext context, Data ticketData, TicketDetails ticketDetails) async {
  final pdf = pw.Document();

  // Build PDF (unchanged from your code)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(10),
      build: (context) => [
        _buildHeader(ticketData, logoImage),
        pw.SizedBox(height: 15),
        _buildPnrWidget(ticketData),
        pw.SizedBox(height: 20),
        _buildTripInformation(ticketData),
        pw.SizedBox(height: 20),
        _buildPassengerDetails(ticketData),
        pw.SizedBox(height: 20),
        _buildPaymentInformation(ticketData),
        pw.SizedBox(height: 20),
        _buildCancellationPolicy(ticketData, ticketDetails),
        pw.SizedBox(height: 20),
        _buildFooter(),
      ],
    ),
  );

  Uint8List bytes = await pdf.save();
  final fileName = "ticket_${DateTime.now().millisecondsSinceEpoch}.pdf";

  if (Platform.isAndroid) {
    if (await _hasStoragePermission()) {
      final ms = MediaStore();

      // 1. Write PDF bytes into temp file
      final tempFilePath = await _writePdfToTemp(bytes, fileName);

      // 2. Save into Downloads folder using MediaStore
      final saveInfo = await ms.saveFile(
        tempFilePath: tempFilePath,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (saveInfo != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ PDF saved in Downloads as $fileName")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to save PDF")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Storage permission denied")),
      );
    }
  } else {
    // iOS or desktop
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ PDF saved at: $filePath")),
    );
  }
}




  // Future<void> _generateAndSavePdf(
  //   BuildContext context,
  //   Data ticketData,
  //   TicketDetails ticketDetails,
  // ) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: PdfPageFormat.a4,
  //       margin: const pw.EdgeInsets.all(10),
  //       build: (context) => [
  //         _buildHeader(ticketData, logoImage),
  //         pw.SizedBox(height: 15),
  //         _buildPnrWidget(ticketData),
  //         pw.SizedBox(height: 20),
  //         _buildTripInformation(ticketData),
  //         pw.SizedBox(height: 20),
  //         _buildPassengerDetails(ticketData),
  //         pw.SizedBox(height: 20),
  //         _buildPaymentInformation(ticketData),
  //         pw.SizedBox(height: 20),
  //         _buildCancellationPolicy(ticketData, ticketDetails),
  //         pw.SizedBox(height: 20),
  //         _buildFooter(),
  //       ],
  //     ),
  //   );

  //   Uint8List bytes = await pdf.save();

  //   String dirPath;
  //   if (Platform.isAndroid) {
  //     dirPath = await ExternalPath.getExternalStoragePublicDirectory(
  //       ExternalPath.DIRECTORY_DOWNLOAD,
  //     );
  //   } else {
  //     final dir = await getApplicationDocumentsDirectory();
  //     dirPath = dir.path;
  //   }

  //   final filePath =
  //       "$dirPath/ticket_${DateTime.now().millisecondsSinceEpoch}.pdf";
  //   final file = File(filePath);
  //   await file.writeAsBytes(bytes);

  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text("✅ PDF saved at: $filePath")));
  // }



  static Future<pw.ImageProvider?> loadAssetImage(String path) async {
    try {
      final ByteData imageData = await rootBundle.load(path);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      return pw.MemoryImage(imageBytes);
    } catch (e) {
      print('Error loading image from $path: $e');
      return null;
    }
  }
}

pw.Widget _buildHeader(Data data, pw.ImageProvider? logoImage) {
  return pw.Container(
    width: double.infinity,
    // padding: const pw.EdgeInsets.all(10),
    // decoration: pw.BoxDecoration(
    //   border: pw.Border.all(color: PdfColors.black),
    // ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Logo section
        if (logoImage != null) ...[
          pw.Container(
            width: 150,
            height: 70,
            child: pw.Image(logoImage, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 20),
        ] else ...[
          // Fallback text logo if image fails to load
          pw.Container(
            width: 80,
            height: 60,
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Hopzy',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ),
          pw.SizedBox(width: 20),
        ],
        // pw.SizedBox(width: 30),
        pw.Spacer(),
        // Content section
        pw.Container(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "HOPZY Solutions Pvt Ltd", // data['operatorName'] ?? 'Bus Operator',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "Operator Contact Helpline : +91-XXXXXXXXXX", // 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "Hopzy Support Emailid : support@hopzy.com", // 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "Hopzy Support Helpline : +91-YYYYYYYYYY", // 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              // pw.SizedBox(height: 5),
              // pw.Row(
              //   children: [
              //     pw.Expanded(
              //       child: pw.Text(
              //         'PNR: ${data['pnr'] ?? ''}',
              //         style: const pw.TextStyle(fontSize: 11),
              //       ),
              //     ),
              //     pw.Expanded(
              //       child: pw.Text(
              //         'Ticket ID: ${data['ticketId'] ?? ''}',
              //         style: const pw.TextStyle(fontSize: 11),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildTripInformation(Data data) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Trip Information',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Operator Name', data.operatorName ?? ''],
        ['TIN', data.ticketId ?? ''],
        ['From / Source', data.from ?? ''],
        ['To / Destination', data.to ?? ''],
        ['Booked At', data.bookedAt ?? ''],
        ['Bus Type', data.bustype ?? ''],
      ]),

      pw.SizedBox(height: 16),

      pw.Text(
        'Boarding Details',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Boarding Point Name', data.boardingPoint!.name ?? ''],
        ['Boarding Address', data.boardingPoint!.name ?? ''],
        ['Boarding Time', data.boardingPoint!.time ?? ''],
        ['Boarding Contact', "56892347856"], //data['boardingContact'] ?? ''],
      ]),

      pw.SizedBox(height: 16),

      pw.Text(
        'Dropping Details',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Dropping Point Name', data.droppingPoint!.name ?? ''],
        ['Dropping Address', data.droppingPoint!.name ?? ''],
        ['Dropping Time', data.droppingPoint!.time ?? ''],
        ['Dropping Contact', "4568935968"], //data['droppingContact'] ?? ''],
      ]),
    ],
  );
}

/// Reusable table builder for key-value pairs
pw.Widget _buildTableN(List<List<String>> rows) {
  return pw.Table(
    border: pw.TableBorder.all(width: 1),
    columnWidths: {
      0: const pw.FlexColumnWidth(2),
      1: const pw.FlexColumnWidth(3),
    },
    children: rows.map((row) {
      return pw.TableRow(
        children: row.map((cell) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(cell, style: pw.TextStyle(fontSize: 12)),
          );
        }).toList(),
      );
    }).toList(),
  );
}

pw.Widget _buildPassengerDetails(Data data) {
  List<String> headers = [
    '#',
    'Name',
    'Gender',
    'Age',
    'Seat',
    'Fare',
    'Seat Status',
  ];

  // Build table rows
  List<pw.TableRow> rows = [];

  // Header row with background color
  rows.add(
    pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.lightBlue100),
      children: headers.map((header) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            header,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        );
      }).toList(),
    ),
  );

  // Passenger rows
  if (data.passengers != null) {
    List<Passengers> passengers = data.passengers! ?? [];
    for (int i = 0; i < passengers.length; i++) {
      var passenger = passengers[i];
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text((i + 1).toString()),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger.name ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger.gender ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger.age?.toString() ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger.seatNo ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                "${data.payment!.currency} ${passenger.fare.toString()}" ?? '',
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger.status ?? ''),
            ),
          ],
        ),
      );
    }
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Passenger Details',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FlexColumnWidth(1), // #
          1: const pw.FlexColumnWidth(3), // Name
          2: const pw.FlexColumnWidth(2), // Gender
          3: const pw.FlexColumnWidth(1), // Age
          4: const pw.FlexColumnWidth(2), // Seat
          5: const pw.FlexColumnWidth(3), // Fare
          6: const pw.FlexColumnWidth(3), // Seat Status
        },
        children: rows,
      ),
    ],
  );
}

pw.Widget _buildCancellationPolicy(Data data, TicketDetails ticketDetails) {
  List<String> headers = ['#', 'Description', 'Refund', 'Charge'];
  List<pw.TableRow> rows = [];

  // Header row with light blue background
  rows.add(
    pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.lightBlue100),
      children: headers.map((header) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            header,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        );
      }).toList(),
    ),
  );

  // Data rows
  if (ticketDetails.cancellationPolicy != null) {
    List<CancellationPolicy> policies = ticketDetails.cancellationPolicy ?? [];
    for (int i = 0; i < policies.length; i++) {
      var policy = policies[i];
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text((i + 1).toString()),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(policy.description ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(policy.refundpercent ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(policy.cancellationcharge ?? ''),
            ),
          ],
        ),
      );
    }
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Cancellation Policy',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      // Table
      pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FlexColumnWidth(1), // #
          1: const pw.FlexColumnWidth(4), // Description
          2: const pw.FlexColumnWidth(2), // Refund
          3: const pw.FlexColumnWidth(2), // Charge
        },
        children: rows,
      ),

      pw.SizedBox(height: 16),

      // Terms & Conditions
      pw.Text(
        'Terms and Conditions',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 6),
      if (termsAndConditions != null)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: List<pw.Widget>.generate(
            termsAndConditions.length,
            (index) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Text(
                "${index + 1}. ${termsAndConditions[index]}",
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
    ],
  );
}

List<String> termsAndConditions = [
  "Tickets once booked cannot be transferred.",
  "Please carry a valid ID proof during the boarding.",
  "Operator is not responsible for delays due to traffic.",
];

pw.Widget _buildPaymentInformation(Data data) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Payment Information',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Status', data.payment!.status ?? ''],
        ['Payment ID', data.payment!.razorpayPaymentId ?? ''],
        ['Amount Paid', "${data.payment!.currency} ${data.totalFare}" ?? ''],
      ]),
    ],
  );
}

pw.Widget _buildTable(List<List<String>> data, {bool hasHeader = true}) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),
    children: data.asMap().entries.map((entry) {
      int index = entry.key;
      List<String> row = entry.value;
      bool isHeader = hasHeader && index == 0;

      return pw.TableRow(
        decoration: isHeader
            ? const pw.BoxDecoration(color: PdfColors.blue200)
            : null,
        children: row.map((cell) {
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: pw.Text(
              cell,
              style: pw.TextStyle(
                color: isHeader ? PdfColors.white : PdfColors.black,
                fontSize: 9,
                fontWeight: isHeader
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
              ),
              textAlign: pw.TextAlign.center,
            ),
          );
        }).toList(),
      );
    }).toList(),
  );
}

pw.Widget _buildFooter() {
  return pw.Container(
    width: double.infinity,
    // padding: const pw.EdgeInsets.all(15),
    // decoration: const pw.BoxDecoration(color: PdfColors.blue200),
    child: pw.Text(
      'Powered by Hopzy Solutions Pvt Ltd © 2025',
      style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildPnrWidget(Data data) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(15),
    decoration: const pw.BoxDecoration(color: PdfColors.blue200),
    child: pw.Text(
      "PNR: ${data.pnr ?? ""} | Departure: ${data.boardingPoint!.time ?? ""}",
      style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
      textAlign: pw.TextAlign.center,
    ),
  );
}
