import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/commonWidgets/custom_trip_list_tile.dart';
import 'package:ridebooking/globels.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/trip_model.dart';
import 'package:ridebooking/screens/seat_selection_screen/seat_selection_screen.dart';
import 'package:ridebooking/screens/trip_details_screen.dart';
import 'package:ridebooking/globels.dart' as globals;
import 'package:ridebooking/utils/app_sizes.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/app_typography.dart';

class AvailableTripsScreen extends StatefulWidget {
  List<Availabletrips>? allTrips;
  // String? selectedDa;
   AvailableTripsScreen({super.key,required this.allTrips});

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<AvailableTripsScreen> {

  late DateTime parsedDate;
  late String dayMonth; // e.g., "6 Aug"
  late String weekday; // e.g., "Wed"

  @override
  void initState() {
    super.initState();
    parsedDate = DateFormat('yyyy-MM-dd').parse(globals.selectedDate);
    dayMonth = DateFormat('d MMM').format(parsedDate);
    weekday = DateFormat('EEE').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.allTrips!.first.src} → ${widget.allTrips!.first.dst}",
            style: TextStyle(
              fontSize: AppSizes.md,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.allTrips!.length} Buses",
            style: TextStyle(
              fontSize: AppSizes.md,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          dayMonth, // e.g., "6 Aug"
          style: TextStyle(
            fontSize: AppSizes.md,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weekday, // e.g., "Wed"
          style: TextStyle(
            fontSize: AppSizes.md,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  ],
),


      ),
      body: ListView.builder(
        itemCount: widget.allTrips?.length ?? 0,
        itemBuilder: (context,index){
          return TripListTile(
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SeatSelectionScreen(trip: widget.allTrips![index],)));
          },
            trip: TripModel(
              tripIdV2: widget.allTrips![index].tripidV2 ?? 'Unknown Trip ID'  ,
              tripId: widget.allTrips![index].tripid ?? 'Unknown Trip ID',
              routeId: widget.allTrips![index].routeid ?? 'Unknown Route ID',
              operatorId: widget.allTrips![index].operatorid ?? 'Unknown Operator ID',
              operatorName: widget.allTrips![index].operatorname ?? 'Unknown Operator',
              srcName: widget.allTrips![index].src ?? 'Unknown Source',
              dstName: widget.allTrips![index].dst ?? 'Unknown Destination',
              departureTime: DateTime.parse(widget.allTrips![index].deptime ?? DateTime.now().toString()),
              arrivalTime: DateTime.parse(widget.allTrips![index].arrtime ?? DateTime.now().toString()),
              busType: widget.allTrips![index].bustype ?? 'Unknown Bus Type',
              availableSeats: widget.allTrips![index].availseats ?? "0",
              totalSeats: widget.allTrips![index].totalseats ?? "",
              price: widget.allTrips![index].fare ?? "0",
            ),
          );
          
          // Card(
          //   margin: const EdgeInsets.all(8.0),
          //   child: ListTile(
          //     title: Text(widget.allTrips![index].operatorname ?? 'src Name'),
          //     subtitle: Text('From: ${widget.allTrips![index].srcname ?? 'Unknown'}\n'
          //         'To: ${widget.allTrips![index].dstname ?? 'Unknown'}\n'
          //         'Date: ${widget.allTrips![index].depaturetime ?? 'Unknown'}'),
          //     trailing: Text('Price: \$${widget.allTrips![index].availseats ?? 0}'),
          //   ),
          // );
        })
    );
  }
}