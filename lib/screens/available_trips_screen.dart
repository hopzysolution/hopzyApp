import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/commonWidgets/custom_trip_list_tile.dart';
import 'package:ridebooking/commonWidgets/date_selecter_view.dart';
import 'package:ridebooking/commonWidgets/filtter_view.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/operator_list_model.dart';
import 'package:ridebooking/models/trip_model.dart';
import 'package:ridebooking/screens/seat_selection_screen/seat_selection_screen.dart';
import 'package:ridebooking/globels.dart' as globals;
import 'package:ridebooking/utils/app_sizes.dart';

class AvailableTripsScreen extends StatefulWidget {
  final List<Trips>? allTrips;
  City? from;
  City? to;
  String? opId;
  AvailableTripsScreen({
    super.key,
    required this.allTrips,
    this.from,
    this.to,
    this.opId,
  });

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<AvailableTripsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenBloc(),
      child: _AvailableTripsContent(
        allTrips: widget.allTrips,
        from: widget.from,
        to: widget.to,
        opId: widget.opId,
      ),
    );
  }
}

class _AvailableTripsContent extends StatefulWidget {
  final List<Trips>? allTrips;
  final City? from;
  final City? to;
  final String? opId;

  const _AvailableTripsContent({
    required this.allTrips,
    this.from,
    this.to,
    this.opId,
  });

  @override
  State<_AvailableTripsContent> createState() => _AvailableTripsContentState();
}

class _AvailableTripsContentState extends State<_AvailableTripsContent> {
  late DateTime selectedDate;
  Key datePickerKey = UniqueKey();

  // Track filtered trips
  List<Trips>? displayedTrips;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').parse(globals.selectedDate);
    displayedTrips = widget.allTrips;
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      // Force DateSelectorView to rebuild with new date
      datePickerKey = UniqueKey();
    });

    String dateSelected = DateFormat('yyyy-MM-dd').format(newDate);
    globals.selectedDate = dateSelected; // Update global state

    context.read<HomeScreenBloc>().add(
      SearchAvailableTripsEvent(
        src: widget.from!,
        dst: widget.to!,
        date: dateSelected,
      ),
    );
  }

  void _onFilterChanged(List<Trips> filteredTrips) {
    setState(() {
      displayedTrips = filteredTrips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is HomeScreenFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          if (state is HomeScreenLoading) {
            return Scaffold(
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (state is HomeScreenFailure) {
            return Scaffold(body: Center(child: Text(state.error)));
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.from!.cityName} → ${widget.to!.cityName}",
                          style: TextStyle(
                            fontSize: AppSizes.md,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${displayedTrips?.length ?? widget.allTrips!.length} Buses",
                          style: TextStyle(
                            fontSize: AppSizes.md,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  DateSelectorView(
                    key: datePickerKey,
                    onDateChanged: _onDateChanged,
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                FilterRowView(
                  allTrips: widget.allTrips,
                  onFilterChanged: _onFilterChanged,
                ),
                Expanded(
                  child: (displayedTrips == null || displayedTrips!.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No buses found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: displayedTrips?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TripListTile(
                              onTap: () {
                                print(
                                  "routeId Check ----->>>>>>>${displayedTrips![index].toJson()}",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeatSelectionScreen(
                                      trip: displayedTrips![index],
                                    ),
                                  ),
                                );
                              },
                              trip: TripModel(
                                tripIdV2:
                                    displayedTrips![index].subtripid ??
                                    'Unknown Trip ID',
                                tripId:
                                    displayedTrips![index].tripid ??
                                    'Unknown Trip ID',
                                routeId:
                                    displayedTrips![index].routeid ??
                                    'Unknown Route ID',
                                operatorId:
                                    displayedTrips![index].operatorid ??
                                    'Unknown Operator ID',
                                operatorName:
                                    displayedTrips![index].operatorname ??
                                    'Unknown Operator',
                                srcName:
                                    displayedTrips![index].src ??
                                    'Unknown Source',
                                dstName:
                                    displayedTrips![index].dst ??
                                    'Unknown Destination',
                                departureTime: DateTime.parse(
                                  displayedTrips![index].deptime ??
                                      DateTime.now().toString(),
                                ),
                                arrivalTime: DateTime.parse(
                                  displayedTrips![index].arrtime ??
                                      DateTime.now().toString(),
                                ),
                                busType:
                                    displayedTrips![index].bustype ??
                                    'Unknown Bus Type',
                                availableSeats:
                                    displayedTrips![index].availseats
                                        .toString() ??
                                    "0",
                                totalSeats:
                                    displayedTrips![index].totalseats
                                        ?.toString() ??
                                    "",
                                price:
                                    displayedTrips![index].fare.toString() ??
                                    "0",
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
