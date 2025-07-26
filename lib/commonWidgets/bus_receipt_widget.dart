
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ridebooking/utils/app_colors.dart';

class BusReceiptWidget extends StatelessWidget {
  final String busServiceName;
  final String route;
  final String boardingPoint;
  final String droppingPoint;
  final String busType;
  final String journeyDate;
  final String boardingTime;
  final String droppingTime;
  final String totalSeats;
  final String seatNumbers;
  final List<PassengerInfo> passengers;
  final String phoneNumber;
  final VoidCallback? onHomePressed;
  final VoidCallback? onDownloadPressed;
  final double basicFare;
  final double reservation;
  final double rounding;
  final double totalFare;
  final bool? isReceipt;

  const BusReceiptWidget(
      {Key? key,
      required this.busServiceName,
      required this.route,
      required this.boardingPoint,
      required this.droppingPoint,
      required this.busType,
      required this.journeyDate,
      required this.boardingTime,
      required this.droppingTime,
      required this.totalSeats,
      required this.seatNumbers,
      required this.passengers,
      required this.phoneNumber,
      this.onHomePressed,
      this.onDownloadPressed,
      required this.basicFare,
      required this.reservation,
      required this.rounding,
      required this.totalFare,
      required this.isReceipt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top section with receipt header and journey details
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isReceipt!
                        ? Center(
                            child: Text(
                              'Receipt',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.neutral100,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 10,
                          ),
                    // Bus Service Name
                    Text(
                      'Bus Service Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.neutral300,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    // Text(
                    //   busServiceName,
                    //   textAlign: TextAlign.left,
                    //   style: TextStyle(
                    //     color: AppColors.neutral100,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // Route Information
                    Text(
                      route,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.neutral100,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Boarding and Dropping Labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Boarding',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.neutral300,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Dropping',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.neutral300,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Boarding and Dropping Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            boardingPoint,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.neutral100,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "--------->",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.neutral100,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            droppingPoint,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.neutral100,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        // Dotted line separator
        DottedLine(
          direction: Axis.horizontal,
          lineLength: 280.0,
          lineThickness: 1.0,
          dashLength: 6.0,
          dashColor: Colors.black,
          dashRadius: 0.0,
          dashGapLength: 4.0,
        ),
        // Bottom section with details
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              // Ticket cutout effect - bottom
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // Bus Type and Journey Date
                    _buildInfoRow('Bus Type', 'Journey Date'),
                    _buildValueRow(busType, journeyDate),
                    const SizedBox(height: 10),
                    // Boarding and Dropping Time
                    _buildInfoRow('Boarding Time', 'Dropping Time'),
                    _buildValueRow(boardingTime, droppingTime),
                    const SizedBox(height: 10),
                    // Total Seats and Seat Numbers
                    _buildInfoRow('Total Seats', 'Seat No.'),
                    _buildValueRow(totalSeats, seatNumbers),
                    // Dotted line
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: 280.0,
                        lineThickness: 1.0,
                        dashLength: 6.0,
                        dashColor: AppColors.neutral500,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                      ),
                    ),
                    // Passenger Information Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Passenger Name',
                            style: TextStyle(
                              color: AppColors.neutral400,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Age',
                            style: TextStyle(
                              color: AppColors.neutral400,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Gender',
                            style: TextStyle(
                              color: AppColors.neutral400,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Passenger Information
                    ...passengers.asMap().entries.map((entry) {
                      int index = entry.key;
                      PassengerInfo passenger = entry.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                            child: Text(
                              textAlign: TextAlign.center,
                              '${index + 1}. ${passenger.name}',
                              style: TextStyle(
                                color: AppColors.neutral900,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Text(
                              textAlign: TextAlign.center,
                              passenger.age.toString(),
                              style: TextStyle(
                                color: AppColors.neutral900,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              textAlign: TextAlign.center,
                              passenger.gender,
                              style: TextStyle(
                                color: AppColors.neutral900,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    // Dotted line
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: 280.0,
                        lineThickness: 1.0,
                        dashLength: 6.0,
                        dashColor: AppColors.neutral500,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                      ),
                    ),
                    // Phone Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone',
                          style: TextStyle(
                            color: AppColors.neutral400,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            color: AppColors.neutral900,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Final dotted line
                    DottedLine(
                      direction: Axis.horizontal,
                      lineLength: 280.0,
                      lineThickness: 1.0,
                      dashLength: 6.0,
                      dashColor: AppColors.primaryBlue,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                    ),
                    const SizedBox(height: 10),
                    // QR Code
                    isReceipt!
                        ? Center(
                            child: Icon(
                              Icons.qr_code,
                              size: 150,
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Basic Fare'),
                                  Text('₹${basicFare.toStringAsFixed(2)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('ASN'),
                                  Text('₹0.00'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Reservation'),
                                  Text('₹${reservation.toStringAsFixed(2)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Rounding'),
                                  Text('₹${rounding.toStringAsFixed(2)}'),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Fare',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '₹${totalFare.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Updated Button Section
        isReceipt!
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onHomePressed,
                        icon: Icon(
                          Icons.home,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        label: Text(
                          "Home Page",
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.primaryBlue, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDownloadPressed,
                        icon: Icon(
                          Icons.download,
                          color: AppColors.neutral50,
                          size: 20,
                        ),
                        label: Text(
                          "Download",
                          style: TextStyle(
                            color: AppColors.neutral50,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownloadPressed,
                    label: Text(
                      "Continue to payment",
                      style: TextStyle(
                        color: AppColors.neutral50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ))
      ],
    );
  }

  Widget _buildInfoRow(String leftLabel, String rightLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftLabel,
          style: TextStyle(
            color: AppColors.neutral400,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          rightLabel,
          style: TextStyle(
            color: AppColors.neutral400,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildValueRow(String leftValue, String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftValue,
          style: TextStyle(
            color: AppColors.neutral900,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          rightValue,
          style: TextStyle(
            color: AppColors.neutral900,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Model class for passenger information
class PassengerInfo {
  final String name;
  final int age;
  final String gender;

  PassengerInfo({
    required this.name,
    required this.age,
    required this.gender,
  });
}

// // Usage Example:
// class ReceiptPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Bus Receipt')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: BusReceiptWidget(
//             busServiceName: 'Premium Express',
//             route: 'Pune to Mumbai Central via Swargate',
//             boardingPoint: 'Swargate Bus Stand',
//             droppingPoint: 'Mumbai Central',
//             busType: 'Ordinary',
//             journeyDate: '19 February 2025',
//             boardingTime: '01:48',
//             droppingTime: '06:00',
//             totalSeats: '2',
//             seatNumbers: '15,16',
//             passengers: [
//               PassengerInfo(name: 'Hiroshi Patel', age: 29, gender: 'M'),
//               PassengerInfo(name: 'Laura Patel', age: 32, gender: 'F'),
//             ],
//             phoneNumber: '+91 9876543210',
//             onHomePressed: () {
//               // Navigate to home page
//               Navigator.popUntil(context, (route) => route.isFirst);
//             },
//             onDownloadPressed: () {
//               // Handle download functionality
//               print('Download receipt');
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }