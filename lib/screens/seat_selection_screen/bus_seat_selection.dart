
import 'package:flutter/material.dart';
import 'package:ridebooking/models/bus_data.dart';

enum SeatStatus {
  available,
  booked,
  femaleOnly,
  maleOnly,
  // femaleBooked,
  // maleBooked,
  unavailable,
}

class BusSeatSelectionScreen extends StatefulWidget {
  final BusData busData; // API data containing seat layout
  final void Function(Set<String>) onSeatsSelected;

  const BusSeatSelectionScreen(
      {Key? key, required this.busData, required this.onSeatsSelected})
      : super(key: key);

  @override
  _BusSeatSelectionScreenState createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  Set<String> selectedSeats = <String>{};
  List<List<Map<String, dynamic>?>> seatLayout = [];
  bool isUpperDeck = true;

  @override
  void initState() {
    super.initState();
    _initializeSeatLayout();
  }

  void _initializeSeatLayout() {
    final seats = widget.busData.seats ?? [];
    final rows = widget.busData.totalRows ?? 10;
    final columns = widget.busData.totalColumns ?? 5;

    seatLayout =
        List.generate(rows, (row) => List.generate(columns, (col) => null));

    for (var seat in seats) {
      final row = seat.row ?? 0;
      final column = seat.column ?? 0;
      final isUpper = (seat.berth ?? '').toLowerCase() == 'upper';

      if (this.isUpperDeck == isUpper &&
          row < seatLayout.length &&
          column < seatLayout[row].length) {
        seatLayout[row][column] = {
          'seatNumber': seat.seatNumber,
          'status': _getSeatStatusFromString(seat.status ?? ''),
          'fare': seat.fare,
          'berth': seat.berth,
          'gender': seat.gender,
          'seatType': seat.seatType ?? 'seater', // default fallback
        };
      }
    }
  }

  SeatStatus _getSeatStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return SeatStatus.available;
      case 'booked':
        return SeatStatus.booked;
      case 'female_only':
        return SeatStatus.femaleOnly;
      case 'male_only':
        return SeatStatus.maleOnly;
      // case 'female_booked':
      //   return SeatStatus.femaleBooked;
      // case 'male_booked':
      //   return SeatStatus.maleBooked;
      default:
        return SeatStatus.unavailable;
    }
  }

  Color getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Colors.green.withOpacity(0.5);
      case SeatStatus.booked:
        return Colors.grey;
      case SeatStatus.femaleOnly:
        return Colors.pink.withOpacity(0.3);
      case SeatStatus.maleOnly:
        return Colors.blue.withOpacity(0.3);
      // case SeatStatus.femaleBooked:
      //   return Colors.pink.withOpacity(0.5);
      // case SeatStatus.maleBooked:
      //   return Colors.blue.withOpacity(0.5);
      default:
        return Colors.grey.shade300;
    }
  }

  IconData getSeatIcon(SeatStatus status) {
    switch (status) {
      case SeatStatus.femaleOnly:
        // case SeatStatus.femaleBooked:
        return Icons.female;
      case SeatStatus.maleOnly:
        // case SeatStatus.maleBooked:
        return Icons.male;
      default:
        return Icons.event_seat;
    }
  }

  bool _canSelectSeat(SeatStatus status) {
    return status == SeatStatus.available ||
        status == SeatStatus.femaleOnly ||
        status == SeatStatus.maleOnly;
  }

  Widget _buildSeat(
      Map<String, dynamic>? seatData, int rowIndex, int colIndex) {
    if (seatData == null) {
      return Flexible(
        child: Container(
          margin: const EdgeInsets.all(2),
        ),
      );
    }

    final seatNumber = seatData['seatNumber'] as String;
    final status = seatData['status'] as SeatStatus;
    final price = seatData['fare'] as int? ?? 0;
    final seatType = seatData['seatType'] as String? ?? 'seater';
    final isSelected = selectedSeats.contains(seatNumber);

    double seatHeight = seatType.toLowerCase() == 'sleeper' ? 200.0 : 85.0;

    return Flexible(
      child: GestureDetector(
        onTap: () {
          if (_canSelectSeat(status)) {
            setState(() {
              isSelected
                  ? selectedSeats.remove(seatNumber)
                  : selectedSeats.add(seatNumber);
              print("Custom widget selected seats:--------->> $selectedSeats");

              widget.onSeatsSelected(selectedSeats);
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          constraints: BoxConstraints(
              minHeight: seatHeight,
              maxHeight: 250,
              minWidth: 80, //50,
              maxWidth: 80),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : getSeatColor(status),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: getSeatColor(status).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                getSeatIcon(status),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(height: 2),
              if (_canSelectSeat(status))
                Text(
                  '₹$price',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (status == SeatStatus.booked
                  // ||
                  //     status == SeatStatus.femaleBooked ||
                  //     status == SeatStatus.maleBooked
                  )
                const Text(
                  'Sold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              // const SizedBox(height: 2),
              // Text(
              //   seatType.toUpperCase(),
              //   style: const TextStyle(
              //     color: Colors.white70,
              //     fontSize: 8,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeckSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isUpperDeck = false;
                  _initializeSeatLayout();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isUpperDeck ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.airline_seat_recline_normal,
                      color: !isUpperDeck ? Colors.white : Colors.grey.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Lower deck',
                      style: TextStyle(
                        color:
                            !isUpperDeck ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isUpperDeck = true;
                  _initializeSeatLayout();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isUpperDeck ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.airline_seat_recline_extra,
                      color: isUpperDeck ? Colors.white : Colors.grey.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Upper deck',
                      style: TextStyle(
                        color:
                            isUpperDeck ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 85,
                maxHeight: 100, //seatHeight,,
                minWidth: 50,
                maxWidth: 80),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Know your seat types',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildLegendItem(
              'Available', Colors.green.withOpacity(0.4), Icons.event_seat),
          _buildLegendItem('Already booked', Colors.grey, Icons.event_seat),
          _buildLegendItem('Available only for female passenger',
              Colors.pink.withOpacity(0.4), Icons.female),
          _buildLegendItem('Available for male passenger',
              Colors.blue.withOpacity(0.4), Icons.male),
          _buildLegendItem('Selected', Colors.orange, Icons.event_seat),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("no of seat ---------->>>>>>${widget.busData.seats!.length}");
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // appBar: AppBar(
      //   title: Text('Select Seats'),
      //   backgroundColor: Colors.red,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                children: [
                  _buildDeckSelector(),

                  // Seats grid
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: seatLayout.asMap().entries.map((rowEntry) {
                        int rowIndex = rowEntry.key;
                        List<Map<String, dynamic>?> row = rowEntry.value;

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Left side seats (usually 2 seats)
                              ...row
                                  .take(2)
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((seatEntry) {
                                int seatIndex = seatEntry.key;
                                return _buildSeat(
                                    seatEntry.value, rowIndex, seatIndex);
                              }),

                              // Aisle space
                              SizedBox(width: 20),

                              // Right side seats (remaining seats)
                              ...row
                                  .skip(2)
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((seatEntry) {
                                int seatIndex = seatEntry.key + 2;
                                return _buildSeat(
                                    seatEntry.value, rowIndex, seatIndex);
                              }),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 20),
                  _buildSeatLegend(),
                ],
              ),
            ),
          ),

          // Bottom selection summary
          // if (selectedSeats.isNotEmpty)
          //   Container(
          //     padding: EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 8,
          //           offset: Offset(0, -2),
          //         ),
          //       ],
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text(
          //               '${selectedSeats.length} seat(s) selected',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 16,
          //               ),
          //             ),
          //             Text(
          //               'Seats: ${selectedSeats.join(", ")}',
          //               style: TextStyle(
          //                 color: Colors.grey.shade600,
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ],
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             // Handle seat selection confirmation
          //             print('Selected seats: $selectedSeats');
          //             widget.onSeatsSelected(selectedSeats.toList());
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.red,
          //             foregroundColor: Colors.white,
          //             padding:
          //                 EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //           ),
          //           child: Text('Continue'),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}

// Example usage with API data
// class BusBookingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Example API data structure
//     final busData = {
//       'totalRows': 12,
//       'totalColumns': 5,
//       'seats': [
//         {
//           'seatNumber': 'L1',
//           'row': 0,
//           'column': 0,
//           'status': 'available',
//           'price': 400.0,
//           'deck': 'lower',
//           'gender': 'any'
//         },
//         {
//           'seatNumber': 'L2',
//           'row': 0,
//           'column': 1,
//           'status': 'female_only',
//           'price': 400.0,
//           'deck': 'lower',
//           'gender': 'female'
//         },
//         // Add more seats as per your API response
//         {
//           'seatNumber': 'U1',
//           'row': 0,
//           'column': 0,
//           'status': 'available',
//           'price': 450.0,
//           'deck': 'upper',
//           'gender': 'any'
//         },
//         // ... more seats
//       ]
//     };

//     return MaterialApp(
//       title: 'Bus Seat Selection',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         fontFamily: 'Roboto',
//       ),
//       home: BusSeatSelectionScreen(busData: busData),
//     );
//   }
// }