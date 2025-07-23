import 'package:flutter/material.dart';
import 'package:ridebooking/models/station_model.dart';

class StationSearchView extends StatefulWidget {
  
  final List<StationDetails> stationList;
   StationSearchView({super.key, required this.stationList});

  @override
  State<StationSearchView> createState() => _StationSearchViewState();
}

class _StationSearchViewState extends State<StationSearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Station')),
      body: ListView.builder(
        itemCount: widget.stationList.length,
        itemBuilder: (context, index) {
          final station = widget.stationList[index];
          return ListTile(
            title: Text(station.station ?? 'Unknown'),
            subtitle: Text(station.state ?? ''),
            onTap: () {
              Navigator.pop(context, station.station); // Return selected value
            },
          );
        },
      ),
    );
  }
}