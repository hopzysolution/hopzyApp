import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/commonWidgets/custom_trip_list_tile.dart';
import 'package:ridebooking/commonWidgets/date_selecter_view.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/trip_model.dart';
import 'package:ridebooking/screens/seat_selection_screen/seat_selection_screen.dart';
import 'package:ridebooking/globels.dart' as globals;
import 'package:ridebooking/utils/app_sizes.dart';

class AvailableTripsScreen extends StatefulWidget {
  List<Availabletrips>? allTrips;
  String? from;
  String? to;
   AvailableTripsScreen({super.key,required this.allTrips,this.from,this.to});

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
      ),
    );
  }
}

class _AvailableTripsContent extends StatefulWidget {
  final List<Availabletrips>? allTrips;
  final String? from;
  final String? to;

  const _AvailableTripsContent({
    required this.allTrips,
    this.from,
    this.to,
  });

  @override
  State<_AvailableTripsContent> createState() => _AvailableTripsContentState();
}

class _AvailableTripsContentState extends State<_AvailableTripsContent> {
  late DateTime selectedDate;
  Key datePickerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').parse(globals.selectedDate);
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
        from: widget.from!,
        to: widget.to!,
        date: dateSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is HomeScreenFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error))
          );
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
            return Center(child: Text(state.error));
          }

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
                  DateSelectorView(
                    key: datePickerKey,
                    onDateChanged: _onDateChanged,
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: widget.allTrips?.length ?? 0,
              itemBuilder: (context, index) {
                return TripListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatSelectionScreen(
                          trip: widget.allTrips![index],
                        )
                      )
                    );
                  },
                  trip: TripModel(
                    tripIdV2: widget.allTrips![index].tripidV2 ?? 'Unknown Trip ID',
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
              }
            )
          );
        }
      ),
    );
  }
}