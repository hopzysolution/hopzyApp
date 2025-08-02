import 'package:flutter/material.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
// import 'package:ridebooking/models/station_model.dart';

class StationSearchView extends StatefulWidget {
  final List<AllAvailabletrips> allAvailabletripsList;

  const StationSearchView({super.key, required this.allAvailabletripsList});

  @override
  State<StationSearchView> createState() => _StationSearchViewState();
}

class _StationSearchViewState extends State<StationSearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<AllAvailabletrips> _filteredStations = [];

  @override
  void initState() {
    super.initState();
    _filteredStations = widget.allAvailabletripsList; // initially show all
    _searchController.addListener(_filterStations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStations);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStations = widget.allAvailabletripsList.where((station) {
        final stationName = station.srcname?.toLowerCase() ?? '';
        return stationName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Station')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search station...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _filteredStations.isEmpty
                ? const Center(child: Text("No station found"))
                : ListView.builder(
                    itemCount: _filteredStations.length,
                    itemBuilder: (context, index) {
                      final station = _filteredStations[index];
                      return ListTile(
                        title: Text(station.srcname ?? 'Unknown'),
                        // subtitle: Text(station.state ?? ''),
                        onTap: () {
                          Navigator.pop(context, station); // Return selected value
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
