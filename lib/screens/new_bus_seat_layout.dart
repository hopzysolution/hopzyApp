// import 'package:flutter/material.dart';

// class NewBusSeatLayout extends StatefulWidget {
//   const NewBusSeatLayout({Key? key}) : super(key: key);

//   @override
//   State<NewBusSeatLayout> createState() => _NewBusSeatLayoutState();
// }

// class _NewBusSeatLayoutState extends State<NewBusSeatLayout> {
//   // Updated seat data for sleeper bus layout
//   final List<Map<String, dynamic>> seatData = [
//     // Lower deck - Left side (2 seats per row)
//     {"seatNo": "L1", "row": 1, "position": "left", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L2", "row": 1, "position": "left", "col": 2, "seatstatus": "BK", "berth": "lower", "gender": "Female"},
//     {"seatNo": "L3", "row": 2, "position": "left", "col": 1, "seatstatus": "BK", "berth": "lower", "gender": "Male"},
//     {"seatNo": "L4", "row": 2, "position": "left", "col": 2, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L5", "row": 3, "position": "left", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L6", "row": 3, "position": "left", "col": 2, "seatstatus": "F", "berth": "lower", "gender": null},
//     {"seatNo": "L7", "row": 4, "position": "left", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L8", "row": 4, "position": "left", "col": 2, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L9", "row": 5, "position": "left", "col": 1, "seatstatus": "BK", "berth": "lower", "gender": "Female"},
//     {"seatNo": "L10", "row": 5, "position": "left", "col": 2, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L11", "row": 6, "position": "left", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L12", "row": 6, "position": "left", "col": 2, "seatstatus": "A", "berth": "lower", "gender": null},

//     // Lower deck - Right side (1 seat per row)
//     {"seatNo": "L13", "row": 1, "position": "right", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L14", "row": 2, "position": "right", "col": 1, "seatstatus": "BK", "berth": "lower", "gender": "Male"},
//     {"seatNo": "L15", "row": 3, "position": "right", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L16", "row": 4, "position": "right", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},
//     {"seatNo": "L17", "row": 5, "position": "right", "col": 1, "seatstatus": "F", "berth": "lower", "gender": null},
//     {"seatNo": "L18", "row": 6, "position": "right", "col": 1, "seatstatus": "A", "berth": "lower", "gender": null},

//     // Upper deck - Left side (2 seats per row)
//     {"seatNo": "U1", "row": 1, "position": "left", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U2", "row": 1, "position": "left", "col": 2, "seatstatus": "BK", "berth": "upper", "gender": "Female"},
//     {"seatNo": "U3", "row": 2, "position": "left", "col": 1, "seatstatus": "M", "berth": "upper", "gender": null},
//     {"seatNo": "U4", "row": 2, "position": "left", "col": 2, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U5", "row": 3, "position": "left", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U6", "row": 3, "position": "left", "col": 2, "seatstatus": "BK", "berth": "upper", "gender": "Male"},
//     {"seatNo": "U7", "row": 4, "position": "left", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U8", "row": 4, "position": "left", "col": 2, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U9", "row": 5, "position": "left", "col": 1, "seatstatus": "F", "berth": "upper", "gender": null},
//     {"seatNo": "U10", "row": 5, "position": "left", "col": 2, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U11", "row": 6, "position": "left", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U12", "row": 6, "position": "left", "col": 2, "seatstatus": "A", "berth": "upper", "gender": null},

//     // Upper deck - Right side (1 seat per row)
//     {"seatNo": "U13", "row": 1, "position": "right", "col": 1, "seatstatus": "BK", "berth": "upper", "gender": "Female"},
//     {"seatNo": "U14", "row": 2, "position": "right", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U15", "row": 3, "position": "right", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U16", "row": 4, "position": "right", "col": 1, "seatstatus": "BK", "berth": "upper", "gender": "Male"},
//     {"seatNo": "U17", "row": 5, "position": "right", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//     {"seatNo": "U18", "row": 6, "position": "right", "col": 1, "seatstatus": "A", "berth": "upper", "gender": null},
//   ];

//   Set<String> selectedSeats = {};
//   final int maxRows = 6;

//   Color getSeatColor(String status, String? gender, bool isSelected) {
//     if (isSelected) return Colors.green;
    
//     switch (status) {
//       case 'A': // Available
//         return Colors.grey.shade200;
//       case 'BK': // Booked
//         return Colors.red.shade300;
//       case 'F': // Female reserved
//         return Colors.pink.shade200;
//       case 'M': // Male reserved
//         return Colors.blue.shade200;
//       default:
//         return Colors.grey.shade400;
//     }
//   }

//   Widget buildBerth(Map<String, dynamic> seat) {
//     final seatNo = seat['seatNo'];
//     final status = seat['seatstatus'];
//     final gender = seat['gender'];
//     final isSelected = selectedSeats.contains(seatNo);
//     final isAvailable = status == 'A' || status == 'F' || status == 'M';

//     return GestureDetector(
//       onTap: isAvailable ? () {
//         setState(() {
//           if (isSelected) {
//             selectedSeats.remove(seatNo);
//           } else {
//             selectedSeats.add(seatNo);
//           }
//         });
//       } : null,
//       child: Container(
//         width: 40,
//         height: 70,
//         margin: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           color: getSeatColor(status, gender, isSelected),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: isSelected ? [
//             BoxShadow(
//               color: Colors.green.withOpacity(0.3),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             )
//           ] : null,
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 seatNo,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: status == 'BK' ? Colors.white : Colors.black87,
//                 ),
//               ),
//               if (gender != null)
//                 Icon(
//                   gender == 'Female' ? Icons.female : Icons.male,
//                   size: 10,
//                   color: status == 'BK' ? Colors.white : 
//                          (gender == 'Female' ? Colors.pink : Colors.blue),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildDeckSection(String deckType) {
//     final deckSeats = seatData.where((seat) => seat['berth'] == deckType).toList();
//     final leftSeats = deckSeats.where((seat) => seat['position'] == 'left').toList();
//     final rightSeats = deckSeats.where((seat) => seat['position'] == 'right').toList();
    
//     return Container(
//       width: 180,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         children: [
//           // Deck header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             decoration: BoxDecoration(
//               color: deckType == 'upper' ? Colors.blue.shade100 : Colors.orange.shade100,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   deckType == 'upper' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                   size: 16,
//                   color: deckType == 'upper' ? Colors.blue.shade700 : Colors.orange.shade700,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   '${deckType == 'upper' ? 'Upper' : 'Lower'} deck',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: deckType == 'upper' ? Colors.blue.shade700 : Colors.orange.shade700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
          
//           // Seats layout
//           ...List.generate(maxRows, (rowIndex) {
//             final row = rowIndex + 1;
//             final leftRowSeats = leftSeats.where((seat) => seat['row'] == row).toList();
//             final rightRowSeats = rightSeats.where((seat) => seat['row'] == row).toList();
            
//             leftRowSeats.sort((a, b) => a['col'].compareTo(b['col']));
            
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 1),
//               child: Row(
//                 children: [
//                   // Left side berths (2 berths)
//                   if (leftRowSeats.length >= 1) buildBerth(leftRowSeats[0]),
//                   if (leftRowSeats.length >= 2) buildBerth(leftRowSeats[1]),
//                   if (leftRowSeats.length == 1) const SizedBox(width: 74), // Placeholder for missing berth
                  
//                   // Aisle
//                   const SizedBox(width: 8),
                  
//                   // Right side berth (1 berth)
//                   if (rightRowSeats.isNotEmpty) buildBerth(rightRowSeats[0]),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildLegend() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Seat Legend',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 16,
//             runSpacing: 8,
//             children: [
//               _buildLegendItem(Colors.grey.shade200, 'Available'),
//               _buildLegendItem(Colors.red.shade300, 'Booked'),
//               _buildLegendItem(Colors.pink.shade200, 'Female Reserved'),
//               _buildLegendItem(Colors.blue.shade200, 'Male Reserved'),
//               _buildLegendItem(Colors.green, 'Selected'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(Color color, String label) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(color: Colors.grey.shade400),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text('Select Seats'),
//         backgroundColor: Colors.blue.shade600,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Driver section
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade800,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.drive_eta, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   'Driver',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
          
//           // Bus layout
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   // Bus decks side by side
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildDeckSection('lower'),
//                       const SizedBox(width: 16),
//                       buildDeckSection('upper'),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   buildLegend(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
          
//           // Bottom selection summary
//           if (selectedSeats.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Selected Seats: ${selectedSeats.join(', ')}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Total: ₹${selectedSeats.length * 1000}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Booking ${selectedSeats.length} seats'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'PROCEED TO BOOK',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SeatLayoutWidget extends StatefulWidget {
  final Map<String, dynamic> seatData;

  const SeatLayoutWidget({Key? key, required this.seatData}) : super(key: key);

  @override
  _SeatLayoutWidgetState createState() => _SeatLayoutWidgetState();
}

class _SeatLayoutWidgetState extends State<SeatLayoutWidget> {
  List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    final layout = widget.seatData['layout'];
    final seatInfo = List<Map<String, dynamic>>.from(layout['seatInfo']);
    final maxRows = int.parse(layout['maxrows']);
    final maxCols = int.parse(layout['maxcols']);

    // Separate upper and lower berth seats
    List<Map<String, dynamic>> upperSeats = seatInfo.where((seat) => seat['berth'] == 'upper').toList();
    List<Map<String, dynamic>> lowerSeats = seatInfo.where((seat) => seat['berth'] == 'lower').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Layout'),
        backgroundColor: Colors.blue[700],
      ),
      body: RotatedBox(
        quarterTurns: 1,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Legend
              // _buildLegend(),
              // SizedBox(height: 20),
              
              // Upper Berth
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upper Berth',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildBerthLayout(upperSeats, maxRows, maxCols, 'upper'),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Lower Berth
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lower Berth',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildBerthLayout(lowerSeats, maxRows, maxCols, 'lower'),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Selected seats info
              if (selectedSeats.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Seats:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        selectedSeats.join(', '),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildLegendItem(Colors.green, 'Available'),
              SizedBox(width: 20),
              _buildLegendItem(Colors.red, 'Booked'),
              SizedBox(width: 20),
              _buildLegendItem(Colors.pink[200]!, 'Female'),
              SizedBox(width: 20),
              _buildLegendItem(Colors.blue[200]!, 'Male'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildBerthLayout(List<Map<String, dynamic>> seats, int maxRows, int maxCols, String berthType) {
    return Container(
      child: Column(
        children: List.generate(maxRows, (rowIndex) {
          
          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(maxCols, (colIndex) {
                // Find seat for this position
                Map<String, dynamic>? seat = seats.firstWhere(
                  (s) => int.parse(s['row'].toString()) == (rowIndex + 1) && 
                         int.parse(s['col'].toString()) == (colIndex + 1),
                  orElse: () => {},
                );

                if (seat.isEmpty) {
                  // Empty space
                  return Container(
                    width: 60,
                    height: 40,
                  );
                }

                return _buildSeat(seat);
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSeat(Map<String, dynamic> seat) {
    String seatNo = seat['seatNo'] ?? '';
    String status = seat['seatstatus'] ?? '';
    String? gender = seat['gender'];
    bool isSelected = selectedSeats.contains(seatNo);

    // Handle gangway (empty spaces)
    if (seatNo == '-' || seat['seattype'] == 'gangway') {
      return Container(
        width: 60,
        height: 40,
      );
    }

    Color seatColor;
    bool isClickable = false;

    switch (status) {
      case 'A': // Available
        seatColor = isSelected ? Colors.blue[300]! : Colors.green;
        isClickable = true;
        break;
      case 'BK': // Booked
        seatColor = Colors.red;
        break;
      case 'F': // Female
        seatColor = Colors.pink[200]!;
        break;
      case 'M': // Male
        seatColor = Colors.blue[200]!;
        break;
      default:
        seatColor = Colors.grey;
    }

    return GestureDetector(
      onTap: isClickable ? () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatNo);
          } else {
            selectedSeats.add(seatNo);
          }
        });
      } : null,
      child: Container(
        width: 60,
        height: 40,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.blue[800]! : Colors.grey[400]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                seatNo,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: status == 'BK' ? Colors.white : Colors.black87,
                ),
              ),
              if (gender != null && gender.isNotEmpty)
                Text(
                  gender[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    color: status == 'BK' ? Colors.white70 : Colors.black54,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


}

// Usage example with dummy data
class SeatLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data based on your API structure
    Map<String, dynamic> seatData = {
      "status": {
        "success": true,
        "message": "success",
        "profiledata": {
          "balance": "-88282.5",
          "mode": "POSTPAID",
          "name": "vaagaiapi",
          "allowopsids": ""
        },
        "code": 200
      },
      "layout": {
        "maxrows": "4",
        "seattype": "Sleeper",
        "maxcols": "5",
        "decktype": "UpperAndLower",
        "isenbldsocialdistancing": "NO",
        "covidblockedseats": "",
        "blockingtype": "Dynamic",
        "cancellationrefrncetime": "2025-07-31 23:50:00",
        "seatInfo": [
          // Upper berth seats
          {
            "seatNo": "U1",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "1",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U3",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "2",
            "gender": "Male",
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U5",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "1",
            "col": "3",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U7",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "1",
            "col": "4",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U9",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "1",
            "col": "5",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U2",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "F",
            "position": "horizontal",
            "row": "2",
            "col": "1",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U4",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "M",
            "position": "horizontal",
            "row": "2",
            "col": "2",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U6",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "2",
            "col": "3",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U8",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "2",
            "col": "4",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U10",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "2",
            "col": "5",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          // Row 3 - Gangway (empty spaces)
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "1",
            "gender": null,
            "seattype": "gangway",
            "berth": "upper"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "2",
            "gender": null,
            "seattype": "gangway",
            "berth": "upper"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "3",
            "gender": null,
            "seattype": "gangway",
            "berth": "upper"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "4",
            "gender": null,
            "seattype": "gangway",
            "berth": "upper"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "5",
            "gender": null,
            "seattype": "gangway",
            "berth": "upper"
          },
          {
            "seatNo": "U11",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "1",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U12",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "2",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U13",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "3",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U14",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "4",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          {
            "seatNo": "U15",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "5",
            "gender": null,
            "seattype": "sleeper",
            "berth": "upper"
          },
          // Lower berth seats
          {
            "seatNo": "L1",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "1",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L3",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "2",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L5",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "3",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L7",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "4",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L9",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "1",
            "col": "5",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L2",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "2",
            "col": "1",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L4",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "2",
            "col": "2",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L6",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "2",
            "col": "3",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L8",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "BK",
            "position": "horizontal",
            "row": "2",
            "col": "4",
            "gender": "Female",
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L10",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "F",
            "position": "horizontal",
            "row": "2",
            "col": "5",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          },
          // Row 3 - Gangway for lower berth (empty spaces)
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "1",
            "gender": null,
            "seattype": "gangway",
            "berth": "lower"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "2",
            "gender": null,
            "seattype": "gangway",
            "berth": "lower"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "3",
            "gender": null,
            "seattype": "gangway",
            "berth": "lower"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "4",
            "gender": null,
            "seattype": "gangway",
            "berth": "lower"
          },
          {
            "seatNo": "-",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "3",
            "col": "5",
            "gender": null,
            "seattype": "gangway",
            "berth": "lower"
          },
          {
            "seatNo": "L11",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "1",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L12",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "2",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L13",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "3",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L14",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "4",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          },
          {
            "seatNo": "L15",
            "fare": 1000,
            "servicetax": 0,
            "isac": true,
            "stperc": "5",
            "convenienceChargePercent": 0,
            "seatstatus": "A",
            "position": "horizontal",
            "row": "4",
            "col": "5",
            "gender": null,
            "seattype": "sleeper",
            "berth": "lower"
          }
        ]
      }
    };

    return SeatLayoutWidget(seatData: seatData);
  }
}