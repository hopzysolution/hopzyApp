
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_bloc.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_event.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/bus_data.dart';
import 'package:ridebooking/models/seat_layout_data_model.dart';
import 'package:ridebooking/screens/seat_selection_screen/bus_seat_selection.dart';
import 'package:ridebooking/screens/seat_selection_screen/enhanced_seat.dart';

class SeatSelectionScreen extends StatefulWidget {
    final Availabletrips? trip;
    const SeatSelectionScreen({Key? key, this.trip});
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

// Seat status enum
enum SeatStatus {
  driver,
  available,
  booked,
  femaleOnly,
  femaleBooked,
  maleOnly,
  maleBooked
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with TickerProviderStateMixin {
  Set<String> selectedSeats = {};
  DraggableScrollableController _bottomSheetController =
      DraggableScrollableController();

 
  Color getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.driver:
        return Colors.grey.shade800;
      case SeatStatus.available:
        return Colors.green;
      case SeatStatus.booked:
        return Colors.grey;
      case SeatStatus.femaleOnly:
        return Colors.pink;
      case SeatStatus.femaleBooked:
        return Colors.pink.withOpacity(0.3);
      case SeatStatus.maleOnly:
        return Colors.blue;
      case SeatStatus.maleBooked:
        return Colors.blue.withOpacity(0.3);
    }
  }

  IconData getSeatIcon(SeatStatus status) {
    switch (status) {
      case SeatStatus.femaleOnly:
      case SeatStatus.femaleBooked:
        return Icons.female;
      case SeatStatus.maleOnly:
      case SeatStatus.maleBooked:
        return Icons.male;
      case SeatStatus.driver:
        return Icons.drive_eta;
      default:
        return Icons.event_seat;
    }
  }

  int? dynamicPrice ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dynamicPrice = widget.trip?.fare != null ? int.tryParse(int.parse(int.parse(widget.trip!.fare.toString()).toString())!) : 0;

  }

 

  @override
  Widget build(BuildContext context) {
    print("Trip details on dashboard:=========>>>>>> ${widget.trip?.toJson()}");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Seats',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
               "${widget.trip!.src} --> ${widget.trip!.dst}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: 
            BlocProvider(create: (context)=> SeatLayoutBloc(widget.trip),
              child: BlocBuilder<SeatLayoutBloc, SeatLayoutState>(
                builder: (context, state) {
                  if (state is SeatLayoutLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SeatLayoutFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  } else if (state is SeatLayoutLoaded) {
                    return _buildSeatSelection(state.seatLayout!);
                  }
                  return Container();
                },
              ),
            ),

 );
  }

  
//  BusData busData = 


  Widget _buildSeatSelection(SeatLayoutDataModel seatLayoutData) {
  
        return       Stack(

        children: [
          // Main content area - seat layout
          Positioned.fill(
              child: BusSeatSelectionScreen(
            busData: BusData.fromJson({
    "totalRows": 8,
    "totalColumns": 5,
    "seats": [
      // Lower Deck
      {
        "seatNumber": "L1",
        "row": 0,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L2",
        "row": 0,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L3",
        "row": 0,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L4",
        "row": 0,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L5",
        "row": 1,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L6",
        "row": 1,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L7",
        "row": 1,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L8",
        "row": 1,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L9",
        "row": 2,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L10",
        "row": 2,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L11",
        "row": 2,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L12",
        "row": 2,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L13",
        "row": 3,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L14",
        "row": 3,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L15",
        "row": 3,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L16",
        "row": 3,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L17",
        "row": 4,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L18",
        "row": 4,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L19",
        "row": 4,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L20",
        "row": 4,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      // Upper Deck
      {
        "seatNumber": "U1",
        "row": 0,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U2",
        "row": 0,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U3",
        "row": 0,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U4",
        "row": 0,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U5",
        "row": 1,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U6",
        "row": 1,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U7",
        "row": 1,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U8",
        "row": 1,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U9",
        "row": 2,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U10",
        "row": 2,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U11",
        "row": 2,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U12",
        "row": 2,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U13",
        "row": 3,
        "column": 0,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U14",
        "row": 3,
        "column": 1,
        "status": "available",
        "fare": int.parse(int.parse(widget.trip!.fare.toString()).toString()),
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U15",
        "row": 3,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(int.parse(int.parse(widget.trip!.fare.toString()).toString()).toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U16",
        "row": 3,
        "column": 4,
        "status": "available",
        "fare": int.parse(int.parse(int.parse(widget.trip!.fare.toString()).toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      }
    ]
  }),
            onSeatsSelected: (Set<String> finaSeat) {
              print(
                  "Parent received 0--abc--finaSeat------selected seats:--------->> $finaSeat");
              setState(() {
                selectedSeats = finaSeat;
              });
              print(
                  "Parent received --abc----selectedSeats------selected seats:--------->> $selectedSeats");
              // Proceed with booking or next navigation
            },
          )
              ),

          // Persistent bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.3, // 20% of screen
            minChildSize: 0.3,
            maxChildSize: 0.8, // 70% of screen
            builder: (BuildContext context, ScrollController scrollController) {
              return EnhancedBusInfoBottomSheet(
                tripData: widget.trip,
                busInfo: BusInfo(
                  busType: widget.trip?.bustype ?? "Sleeper",
                //   coSaving: "5",
                  date: "2025-07-29",
                  name: "Neo Electric Bus",
                  operator: widget.trip?.operatorname ?? "Unknown Operator",
                  rating: 4.5,
                  route: "${widget.trip!.src} --> ${widget.trip!.dst}",
                  time:"${ DateFormat('hh:mm a').format(DateTime.parse(widget.trip!.deptime.toString()))} --> ${ DateFormat('hh:mm a').format(DateTime.parse(widget.trip!.arrtime.toString()))}" ?? "10:00 AM",
                ),
                scrollController: scrollController, // pass controller here

                selectedSeats: selectedSeats,
              );
            },
          ),
        ],
      );
   
  }

  Widget _buildLegendItem(String text, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Container(
            width: 32,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }
}




 // Sample seat data - you can modify this based on your bus layout
//   List<List<SeatStatus?>> seatLayout = [
//     [null, null, null, null, SeatStatus.driver],
//     [
//       SeatStatus.available,
//       SeatStatus.available,
//       null,
//       SeatStatus.available,
//       SeatStatus.available
//     ],
//     [
//       SeatStatus.available,
//       SeatStatus.available,
//       null,
//       SeatStatus.available,
//       SeatStatus.available
//     ],
//     [

//       SeatStatus.available,
//       SeatStatus.available,
//       null,
//       SeatStatus.available,
//       SeatStatus.booked
//     ],
//     [
//       SeatStatus.available,
//       SeatStatus.available,
//       null,
//       SeatStatus.available,
//       SeatStatus.booked
//     ],
//     [
//       SeatStatus.femaleOnly,
//       SeatStatus.femaleOnly,
//       null,
//       SeatStatus.available,
//       SeatStatus.booked
//     ],
//     [
//       SeatStatus.femaleOnly,
//       SeatStatus.femaleOnly,
//       null,
//       SeatStatus.available,
//       SeatStatus.booked
//     ],
//     [
//       SeatStatus.femaleOnly,
//       SeatStatus.booked,
//       null,
//       SeatStatus.available,
//       SeatStatus.available
//     ],
//     [
//       SeatStatus.available,
//       SeatStatus.available,
//       null,
//       SeatStatus.available,
//       SeatStatus.available
//     ],
//     [
//       SeatStatus.available,
//       SeatStatus.available,
//       SeatStatus.available,
//       SeatStatus.available,
//       SeatStatus.available
//     ],
//   ];











              // SingleChildScrollView(
              //   padding: EdgeInsets.only(
              //     left: 16,
              //     right: 16,
              //     top: 16,
              //     bottom: MediaQuery.of(context).size.height *
              //         0.25, // Leave space for bottom sheet
              //   ),
              //   child: Column(
              //     children: [
              //       // Seats grid
              //       Container(
              //         padding: EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Column(
              //           children: seatLayout.asMap().entries.map((rowEntry) {
              //             int rowIndex = rowEntry.key;
              //             List<SeatStatus?> row = rowEntry.value;

              //             return Padding(
              //               padding: EdgeInsets.symmetric(vertical: 4),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: row.asMap().entries.map((seatEntry) {
              //                   int seatIndex = seatEntry.key;
              //                   SeatStatus? seatStatus = seatEntry.value;
              //                   int globalSeatIndex = rowIndex * 5 + seatIndex;

              //                   if (seatStatus == null) {
              //                     return Expanded(
              //                       child: SizedBox(height: 40),
              //                     );
              //                   }

              //                   return Expanded(
              //                     child: GestureDetector(
              //                       onTap: () {
              //                         if (seatStatus == SeatStatus.available ||
              //                             seatStatus == SeatStatus.femaleOnly ||
              //                             seatStatus == SeatStatus.maleOnly) {
              //                           setState(() {
              //                             if (selectedSeats
              //                                 .contains(globalSeatIndex)) {
              //                               selectedSeats.remove(globalSeatIndex);
              //                             } else {
              //                               selectedSeats.add(globalSeatIndex);
              //                             }
              //                           });
              //                         }
              //                       },
              //                       child: Container(
              //                         margin: EdgeInsets.all(2),
              //                         height: 40,
              //                         decoration: BoxDecoration(
              //                           color: selectedSeats
              //                                   .contains(globalSeatIndex)
              //                               ? Colors.orange
              //                               : getSeatColor(seatStatus),
              //                           borderRadius: BorderRadius.circular(6),
              //                           border: Border.all(
              //                             color: getSeatColor(seatStatus)
              //                                 .withOpacity(0.3),
              //                             width: 1,
              //                           ),
              //                         ),
              //                         child: Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           children: [
              //                             Icon(
              //                               getSeatIcon(seatStatus),
              //                               color: Colors.white,
              //                               size: 16,
              //                             ),
              //                             if (seatStatus ==
              //                                     SeatStatus.available ||
              //                                 seatStatus ==
              //                                     SeatStatus.femaleOnly ||
              //                                 seatStatus == SeatStatus.maleOnly)
              //                               Text(
              //                                 '₹400',
              //                                 style: TextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 8,
              //                                   fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                             if (seatStatus == SeatStatus.booked ||
              //                                 seatStatus ==
              //                                     SeatStatus.femaleBooked ||
              //                                 seatStatus == SeatStatus.maleBooked)
              //                               Text(
              //                                 'Sold',
              //                                 style: TextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 8,
              //                                 ),
              //                               ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }).toList(),
              //               ),
              //             );
              //           }).toList(),
              //         ),
              //       ),

              //       SizedBox(height: 20),

              //       // Seat type legend
              //       Container(
              //         padding: EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Know your seat types',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //             SizedBox(height: 16),
              //             _buildLegendItem(
              //                 'Available', Colors.green, Icons.event_seat),
              //             _buildLegendItem(
              //                 'Already booked', Colors.grey, Icons.event_seat),
              //             _buildLegendItem('Available only for female passenger',
              //                 Colors.pink, Icons.female),
              //             // _buildLegendItem('Booked by female passenger',
              //             //     Colors.pink.withOpacity(0.3), Icons.female),
              //             _buildLegendItem('Available for male passenger',
              //                 Colors.blue, Icons.male),
              //             // _buildLegendItem('Booked by male passenger',
              //             //     Colors.blue.withOpacity(0.3), Icons.male),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),