import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridebooking/commonWidgets/custom_trip_list_tile.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/models/trip_model.dart';
import 'package:ridebooking/screens/trip_details_screen.dart';

class AvailableTripsScreen extends StatefulWidget {
  List<Availabletrips>? allTrips;
   AvailableTripsScreen({super.key,required this.allTrips});

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<AvailableTripsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Trips'),
      ),
      body: ListView.builder(
        itemCount: widget.allTrips?.length ?? 0,
        itemBuilder: (context,index){
          return TripListTile(
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailsScreen()));
          },
            trip: TripModel(
              tripIdV2: widget.allTrips![index].tripidV2 ?? 'Unknown Trip ID'  ,
              tripId: widget.allTrips![index].tripid ?? 'Unknown Trip ID',
              routeId: widget.allTrips![index].routeid ?? 'Unknown Route ID',
              operatorId: widget.allTrips![index].operatorid ?? 'Unknown Operator ID',
              operatorName: widget.allTrips![index].operatorname ?? 'Unknown Operator',
              srcName: widget.allTrips![index].srcname ?? 'Unknown Source',
              dstName: widget.allTrips![index].dstname ?? 'Unknown Destination',
              departureTime: DateTime.parse(widget.allTrips![index].depaturetime ?? DateTime.now().toString()),
              arrivalTime: DateTime.parse(widget.allTrips![index].arrivaltime ?? DateTime.now().toString()),
              busType: widget.allTrips![index].bustype ?? 'Unknown Bus Type',
              availableSeats: widget.allTrips![index].availseats ?? "0",
              totalSeats: widget.allTrips![index].totalseats ?? "",
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