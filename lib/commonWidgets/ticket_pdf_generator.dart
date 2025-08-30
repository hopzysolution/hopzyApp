import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';

class TicketPdfGenerator {
  
  pw.ImageProvider? logoImage;
  Future<void> downloadPdf(BuildContext context, Map<String, dynamic> ticketData) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
         logoImage =   await loadAssetImage("assets/images/Hopzy primary black & blue Pin.png");
        await _generateAndSavePdf(context, ticketData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Permission denied")),
        );
      }
    } else {
      await _generateAndSavePdf(context, ticketData);
    }
  }

  Future<void> _generateAndSavePdf(BuildContext context, Map<String, dynamic> ticketData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10),
        build: (context) => [
          _buildHeader(ticketData,logoImage),
          pw.SizedBox(height: 15),
          _buildPnrWidget(ticketData),
          pw.SizedBox(height: 20),
          _buildTripInformation(ticketData),
          pw.SizedBox(height: 20),
          _buildPassengerDetails(ticketData),
          pw.SizedBox(height: 20),
          _buildPaymentInformation(ticketData),
          pw.SizedBox(height: 20),
          _buildCancellationPolicy(ticketData),
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );

    Uint8List bytes = await pdf.save();

    String dirPath;
    if (Platform.isAndroid) {
      dirPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    }

    final filePath = "$dirPath/ticket_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ PDF saved at: $filePath")),
    );
  }

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

  pw.Widget _buildHeader(Map<String, dynamic> data, pw.ImageProvider? logoImage) {
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
            child: pw.Image(
              logoImage,
              fit: pw.BoxFit.contain,
            ),
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
               "HOPZY Solutions Pvt Ltd",// data['operatorName'] ?? 'Bus Operator',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
               "Operator Contact Helpline : +91-XXXXXXXXXX",// 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 5),
               pw.Text(
               "Hopzy Support Emailid : support@hopzy.com",// 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 5),
               pw.Text(
               "Hopzy Support Helpline : +91-YYYYYYYYYY",// 'Bus Ticket - ${data['ticketStatus'] ?? 'Confirmed'}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
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

pw.Widget _buildTripInformation(Map<String, dynamic> data) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Trip Information',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Operator Name', data['operatorName'] ?? ''],
        ['TIN', data['tin'] ?? ''],
        ['From / Source', data['from'] ?? ''],
        ['To / Destination', data['to'] ?? ''],
        ['Booked At', data['bookedAt'] ?? ''],
        ['Bus Type', data['busType'] ?? ''],
      ]),

      pw.SizedBox(height: 16),

      pw.Text(
        'Boarding Details',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Boarding Point Name', data['boardingVenue'] ?? ''],
        ['Boarding Address', data['boardingAddress'] ?? ''],
        ['Boarding Time', data['boardingTime'] ?? ''],
        ['Boarding Contact', data['boardingContact'] ?? ''],
      ]),

      pw.SizedBox(height: 16),

      pw.Text(
        'Dropping Details',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Dropping Point Name', data['droppingVenue'] ?? ''],
        ['Dropping Address', data['droppingAddress'] ?? ''],
        ['Dropping Time', data['droppingTime'] ?? ''],
        ['Dropping Contact', data['droppingContact'] ?? ''],
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
            child: pw.Text(
              cell,
              style: pw.TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
      );
    }).toList(),
  );
}

pw.Widget _buildPassengerDetails(Map<String, dynamic> data) {
  List<String> headers = ['#', 'Name', 'Gender', 'Age', 'Seat', 'Fare', 'Seat Status'];

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
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    ),
  );

  // Passenger rows
  if (data['passengers'] != null) {
    List<dynamic> passengers = data['passengers'];
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
              child: pw.Text(passenger['name'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger['gender'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger['age']?.toString() ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger['seat'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger['fare'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(passenger['seatStatus'] ?? ''),
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

pw.Widget _buildCancellationPolicy(Map<String, dynamic> data) {
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
  if (data['cancellationPolicy'] != null) {
    List<dynamic> policies = data['cancellationPolicy'];
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
              child: pw.Text(policy['description'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(policy['refund'] ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(policy['charge'] ?? ''),
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
      if (data['terms'] != null)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: List<pw.Widget>.generate(
            data['terms'].length,
            (index) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Text(
                "${index + 1}. ${data['terms'][index]}",
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
    ],
  );
}

  pw.Widget _buildPaymentInformation(Map<String, dynamic> data) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Payment Information',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),

      _buildTableN([
        ['Status', data['paymentStatus'] ?? ''],
        ['Payment ID', data['paymentId'] ?? ''],
        ['Amount Paid', data['amountPaid'] ?? ''],
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
                  color:isHeader? PdfColors.white: PdfColors.black,
                  fontSize: 9,
                  fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
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
        style: const pw.TextStyle(fontSize: 10,color: PdfColors.white),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

   pw.Widget _buildPnrWidget(Map<String, dynamic> data) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(color: PdfColors.blue200),
      child: pw.Text(
        "PNR: ${data[""]??""} | Departure: ${data["departreTime"]??""}",
        style: const pw.TextStyle(fontSize: 10,color: PdfColors.white),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
