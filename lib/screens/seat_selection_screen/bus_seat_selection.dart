
import 'package:flutter/material.dart';
import 'package:ridebooking/models/bus_data.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/utils/app_colors.dart';

enum SeatStatus {
  available,
  booked,
  // femaleOnly,
  // maleOnly,
  femaleBooked,
  maleBooked,
  unavailable,
}

class BusSeatSelectionScreen extends StatefulWidget {
  final BusData busData; // API data containing seat layout
  final void Function(Set<SeatModell>) onSeatsSelected;

  const BusSeatSelectionScreen(
      {Key? key, required this.busData, required this.onSeatsSelected})
      : super(key: key);

  @override
  _BusSeatSelectionScreenState createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  Set<SeatModell> selectedSeats = <SeatModell>{};
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
      // case 'female_only':
      //   return SeatStatus.femaleOnly;
      // case 'male_only':
      //   return SeatStatus.maleOnly;
      case 'femalebooked':
        return SeatStatus.femaleBooked;
      case 'malebooked':
        return SeatStatus.maleBooked;
      default:
        return SeatStatus.unavailable;
    }
  }

  Color getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Colors.white;
      case SeatStatus.booked:
        return Colors.black;
      // case SeatStatus.femaleOnly:
      //   return Colors.pink;
      // case SeatStatus.maleOnly:
      //   return Colors.blue;
      case SeatStatus.femaleBooked:
        return Colors.pink;//.withOpacity(0.5);
      case SeatStatus.maleBooked:
        return Colors.blue;//.withOpacity(0.5);
      default:
        return Colors.white;
    }
  }

  IconData getSeatIcon(SeatStatus status) {
    switch (status) {
      // case SeatStatus.femaleOnly:
        case SeatStatus.femaleBooked:
        return Icons.female;
      // case SeatStatus.maleOnly:
        case SeatStatus.maleBooked:
        return Icons.male;
      default:
        return Icons.event_seat;
    }
  }

  bool _canSelectSeat(SeatStatus status) {
    return status == SeatStatus.available ;
    // ||
    //     status == SeatStatus.femaleOnly ||
    //     status == SeatStatus.maleOnly;
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
  
  // Check if seat is selected - this should be calculated each time
  bool isSelected = selectedSeats.any((seat) => seat.seatNo == seatNumber);

  double seatHeight = seatType.toLowerCase() == 'sleeper' ? 200.0 : 85.0;

  return Flexible(
    child: GestureDetector(
      onTap: () {
        if (_canSelectSeat(status)) {
          setState(() {
            if (isSelected) {
              // Remove seat if already selected
              selectedSeats.removeWhere((seat) => seat.seatNo == seatNumber);
            } else {
              // Add seat if not selected
              selectedSeats.add(SeatModell(
                seatNo: seatNumber, 
                fare: price, 
                available: status.name
              ));
            }
            
            print("Custom widget selected seats:--------->> ${!isSelected}");
            widget.onSeatsSelected(selectedSeats);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        constraints: BoxConstraints(
          minHeight: 95, //seatHeight,
          maxHeight: 250,
          minWidth: 50, //50,
          maxWidth: 80
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : getSeatColor(status),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected 
              ? AppColors.accent 
              : status == SeatStatus.available 
                ? Colors.green 
                : getSeatColor(status),
            width: 2,
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
          status==SeatStatus.available||status==SeatStatus.booked?SizedBox():  Icon(
              getSeatIcon(status),
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(height: 2),
            if (_canSelectSeat(status))
              Text(
                '₹$price',
                style: const TextStyle(
                  color: AppColors.neutral900,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (status == SeatStatus.booked ||
                     status == SeatStatus.femaleBooked ||
                     status == SeatStatus.maleBooked)
               Text(
                'Sold',
                style: TextStyle(
                  color:status==SeatStatus.booked?Colors.white: AppColors.neutral900,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
                  color: !isUpperDeck ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.airline_seat_recline_normal,
                    //   color: !isUpperDeck ? Colors.white : Colors.grey.shade600,
                    //   size: 20,
                    // ),
                    SizedBox(width: 8),
                    Text(
                      'Lower',
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
                  color: isUpperDeck ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.airline_seat_recline_extra,
                    //   color: isUpperDeck ? Colors.white : Colors.grey.shade600,
                    //   size: 20,
                    // ),
                    SizedBox(width: 8),
                    Text(
                      'Upper',
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
              border: Border.all(
                color: color,
                width: 2,

              ),
              color:label=="Selected"?color:label=="Already booked"?color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(""),
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
              'Available', Colors.green, Icons.event_seat),
          _buildLegendItem('Already booked', AppColors.neutral900, Icons.event_seat),
          _buildLegendItem('Available only for female passenger',
              Colors.pink, Icons.female),
          _buildLegendItem('Available for male passenger',
              Colors.blue, Icons.male),
          _buildLegendItem('Selected', AppColors.accent, Icons.event_seat),
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

















// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:ridebooking/models/seat_layout_data_model.dart';

// enum SeatStatus {
//   available,
//   booked,
//   femaleOnly,
//   maleOnly,
//   unavailable,
// }

// class BusSeatSelectionScreen extends StatefulWidget {
//   final SeatLayoutDataModel seatLayoutData;
//   final void Function(Set<String>) onSeatsSelected;

//   const BusSeatSelectionScreen({
//     Key? key,
//     required this.seatLayoutData,
//     required this.onSeatsSelected,
//   }) : super(key: key);

//   @override
//   _BusSeatSelectionScreenState createState() => _BusSeatSelectionScreenState();
// }

// class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
//   Set<String> selectedSeats = <String>{};
//   List<List<Map<String, dynamic>?>> seatLayout = [];
//   bool isUpperDeck = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSeatLayout();
//   }

//   void _initializeSeatLayout() {
//     final seats = widget.seatLayoutData.layout?.seatInfo ?? [];
    
//     // Fix: maxrows represents the number of rows, maxcols represents the number of columns
//     final totalRows = int.tryParse(widget.seatLayoutData.layout?.maxrows ?? '4') ?? 4;
//     final totalCols = int.tryParse(widget.seatLayoutData.layout?.maxcols ?? '17') ?? 17;

//     print("Layout dimensions: $totalRows rows x $totalCols columns");
//     print("Total seats in data: ${seats.length}");

//     // Initialize the seat layout with correct dimensions
//     seatLayout = List.generate(totalRows, (row) => List.generate(totalCols, (col) => null));
    
//     for (var seat in seats) {
//       print("Processing seat: ${seat.seatNo}, row: ${seat.row}, col: ${seat.col}, berth: ${seat.berth}, status: ${seat.seatstatus}");
      
//       // Fix: Convert to 0-based indexing (JSON uses 1-based)
//       final row = (int.tryParse(seat.row ?? '1') ?? 1) - 1;
//       final column = (int.tryParse(seat.col ?? '1') ?? 1) - 1;
//       final isUpper = (seat.berth ?? '').toLowerCase() == 'upper';

//       // Check if we should display this seat based on current deck selection
//       if (this.isUpperDeck == isUpper &&
//           row >= 0 && row < seatLayout.length &&
//           column >= 0 && column < seatLayout[row].length) {
        
//         print("Adding seat ${seat.seatNo} at position [$row][$column]");
        
//         seatLayout[row][column] = {
//           'seatNo': seat.seatNo,
//           'seatstatus': _getSeatStatusFromString(seat.seatstatus ?? ''),
//           'fare': seat.fare ?? 0,
//           'berth': seat.berth ?? 'lower',
//           'gender': seat.gender ?? 'unisex',
//           'seattype': seat.seattype ?? 'seat',
//         };
//       }
//     }

//     // Debug: Print the layout
//     print("Seat layout for ${isUpperDeck ? 'upper' : 'lower'} deck:");
//     for (int i = 0; i < seatLayout.length; i++) {
//       String rowStr = "Row $i: ";
//       for (int j = 0; j < seatLayout[i].length; j++) {
//         if (seatLayout[i][j] != null) {
//           rowStr += "${seatLayout[i][j]!['seatNo']} ";
//         } else {
//           rowStr += "- ";
//         }
//       }
//       print(rowStr);
//     }
//   }

//   SeatStatus _getSeatStatusFromString(String status) {
//     switch (status.toLowerCase()) {
//       case 'a':
//         return SeatStatus.available;
//       case 'booked':
//         return SeatStatus.booked;
//       case 'female_only':
//         return SeatStatus.femaleOnly;
//       case 'male_only':
//         return SeatStatus.maleOnly;
//       default:
//         return SeatStatus.unavailable;
//     }
//   }

//   Color getSeatColor(SeatStatus status) {
//     switch (status) {
//       case SeatStatus.available:
//         return Colors.green.withOpacity(0.5);
//       case SeatStatus.booked:
//         return Colors.grey;
//       case SeatStatus.femaleOnly:
//         return Colors.pink.withOpacity(0.3);
//       case SeatStatus.maleOnly:
//         return Colors.blue.withOpacity(0.3);
//       default:
//         return Colors.grey.shade300;
//     }
//   }

//   IconData getSeatIcon(SeatStatus status) {
//     switch (status) {
//       case SeatStatus.femaleOnly:
//         return Icons.female;
//       case SeatStatus.maleOnly:
//         return Icons.male;
//       default:
//         return Icons.event_seat;
//     }
//   }

//   bool _canSelectSeat(SeatStatus status) {
//     print('Checking seat status: $status');
//     return status == SeatStatus.available ||
//         status == SeatStatus.femaleOnly ||
//         status == SeatStatus.maleOnly;
//   }

//   Widget _buildSeat(Map<String, dynamic>? seatData, int rowIndex, int colIndex) {
//     if (seatData == null) {
//       return Flexible(child: Container(margin: const EdgeInsets.all(2)));
//     }

//     final seatNumber = seatData['seatNo'] as String;
//     final status = seatData['seatstatus'] as SeatStatus;
//     final price = seatData['fare'] as int? ?? 0;
//     final seatType = seatData['seattype'] as String? ?? 'seat';
//     final isSelected = selectedSeats.contains(seatNumber);
    
//     // Skip seats with "-" as seat number (gangways)
//     if (seatNumber == "-") {
//       return Container(margin: const EdgeInsets.all(2));
//     }

//     double seatHeight = seatType.toLowerCase() == 'sleeper' ? 100.0 : 85.0;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           if (_canSelectSeat(status)) {
//             setState(() {
//               isSelected ? selectedSeats.remove(seatNumber) : selectedSeats.add(seatNumber);
//               widget.onSeatsSelected(selectedSeats);
//             });
//           }
//         },
//         child: Container(
//           margin: const EdgeInsets.all(2),
//           constraints: BoxConstraints(
//               minHeight: 45,//seatHeight,
//               maxHeight: 120,//seatType.toLowerCase() == 'sleeper' ? 120 : 100,
//               minWidth: 40,
//               maxWidth: 100),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.orange : getSeatColor(status),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: getSeatColor(status).withOpacity(0.3),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 2,
//                 offset: const Offset(0, 1),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(getSeatIcon(status), color: Colors.white, size: 16),
//               const SizedBox(height: 2),
//               Text(seatNumber,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 8,
//                     fontWeight: FontWeight.bold,
//                   )),
//               const SizedBox(height: 2),
//               if (_canSelectSeat(status))
//                 Text('₹$price',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                     ))
//               else if (status == SeatStatus.booked)
//                 const Text('Sold',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 9,
//                       fontWeight: FontWeight.w500,
//                     )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeckSelector() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _buildDeckOption(false, Icons.airline_seat_recline_normal, 'Lower deck'),
//           _buildDeckOption(true, Icons.airline_seat_recline_extra, 'Upper deck'),
//         ],
//       ),
//     );
//   }

//   Widget _buildDeckOption(bool upper, IconData icon, String label) {
//     final selected = upper == isUpperDeck;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             isUpperDeck = upper;
//             selectedSeats.clear(); // Clear selections when switching decks
//             _initializeSeatLayout();
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: selected ? Colors.red : Colors.transparent,
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: selected ? Colors.white : Colors.grey.shade600, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: selected ? Colors.white : Colors.grey.shade600,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendItem(String label, Color color, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 40,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Icon(icon, color: Colors.white, size: 14),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(label,
//                 style: TextStyle(fontSize: 14, color: Colors.black87)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSeatLegend() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Know your seat types',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           SizedBox(height: 16),
//           _buildLegendItem('Available', Colors.green.withOpacity(0.4), Icons.event_seat),
//           _buildLegendItem('Already booked', Colors.grey, Icons.event_seat),
//           _buildLegendItem('Female only', Colors.pink.withOpacity(0.4), Icons.female),
//           _buildLegendItem('Male only', Colors.blue.withOpacity(0.4), Icons.male),
//           _buildLegendItem('Selected', Colors.orange, Icons.event_seat),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 left: 16,
//                 right: 16,
//                 top: 16,
//                 bottom: MediaQuery.of(context).size.height * 0.25,
//               ),
//               child: Column(
//                 children: [
//                   _buildDeckSelector(),
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Spacer(),
//                             Icon(
//                               PhosphorIcons.steeringWheel(),
//                               color: Colors.grey,
//                               size: 32.0,
//                             ),
//                             SizedBox(width: 20),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         ...seatLayout.asMap().entries.map((rowEntry) {
//                           int rowIndex = rowEntry.key;
//                           List<Map<String, dynamic>?> row = rowEntry.value;
//                           return Padding(
//                             padding: EdgeInsets.symmetric(vertical: 3),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 // Left side seats (first 2 columns with some spacing)
//                                 ...row.take(9).toList().asMap().entries.map(
//                                   (seatEntry) => _buildSeat(seatEntry.value, rowIndex, seatEntry.key),
//                                 ),
//                                 SizedBox(width: 20), // Aisle gap
//                                 // Right side seats (remaining columns)
//                                 ...row.skip(9).toList().asMap().entries.map(
//                                   (seatEntry) => _buildSeat(seatEntry.value, rowIndex, seatEntry.key + 9),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   _buildSeatLegend(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }