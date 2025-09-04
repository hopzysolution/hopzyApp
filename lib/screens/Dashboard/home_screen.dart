import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_bloc.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_repository.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/screens/trip_planner.dart';
// import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  DateTime selectedDate = DateTime.now(); //DateTime.now();

  AllAvailabletrips? selectedFromStation;
  AllAvailabletrips? selectedToStation;

  // List<AllAvailabletrips> getFromOptions2(List<AllAvailabletrips> trips) {
  //   final Map<String, Map<String, String>> unique = {};
  //   for (var trip in trips) {
  //     if (!unique.containsKey(trip.srcid)) {
  //       unique[trip.srcid ?? ""] = {
  //         'label': trip.srcname ?? "",
  //         'value': trip.srcid ?? "",
  //         'routeid': trip.routeid ?? "",
  //       };
  //     }
  //   }
  //   return unique.values.toList();
  // }

  List<AllAvailabletrips> getFromOptions(List<AllAvailabletrips> trips) {
    final Map<String, AllAvailabletrips> unique = {};
    for (var trip in trips) {
      if (trip.srcid != null && !unique.containsKey(trip.srcid)) {
        unique[trip.srcid!] = AllAvailabletrips(
          srcname: trip.srcname ?? "",
          srcid: trip.srcid ?? "",
          routeid: trip.routeid ?? "",
        );
      }
    }
    return unique.values.toList();
  }

  List<AllAvailabletrips> getToOptions({
    required List<AllAvailabletrips> trips,
    required AllAvailabletrips fromOption,
  }) {
    final Map<String, AllAvailabletrips> uniqueDstMap = {};

    final filtered = trips.where(
      (trip) =>
          trip.routeid == fromOption.routeid && trip.srcid == fromOption.srcid,
    );
    for (var trip in filtered) {
      // print("--------getToOptions===${trip.toJson()}");
      if (trip.dstid != null && !uniqueDstMap.containsKey(trip.dstid)) {
        uniqueDstMap[trip.dstid!] = AllAvailabletrips(
          ////////////
          dstname: trip.srcname ?? "", //check this
          dstid: trip.srcid ?? "",
          srcid: trip.dstid,
          srcname: trip.dstname ?? "",
          ////////////
          arrivaltime: trip.arrivaltime,
          availseats: trip.availseats,
          bustype: trip.bustype,
          depaturetime: trip.depaturetime,
          operatorid: trip.operatorid,
          operatorname: trip.operatorname,
          routeid: trip.routeid,
          subtripid: trip.subtripid,
          totalseats: trip.totalseats,
          tripid: trip.tripid,
          tripidV2: trip.tripidV2,
        );
      }
    }

    return uniqueDstMap.values.toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  saveSelectedSeat();
  }
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenBloc(),
      child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeScreenFailure) {
            ToastMessage().showErrorToast(state.error);
          }
          if (state is AllTripSuccessState) {
            Navigator.pushNamed(
              context,
              Routes.availableTrips,
              arguments: {'allTrips': state.allTrips,
                          'from': selectedFromStation!.srcid!,
                          'to': selectedToStation!.srcid!,
                          },
            );
          }
        },
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            if (state is HomeScreenLoading || state is HomeScreenInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // if (state is HomeScreenFailure) {
            //   return Center(
            //     child: Text(
            //       state.error,
            //       style: const TextStyle(color: Colors.red, fontSize: 16),
            //     ),
            //   );
            // }

            final List<AllAvailabletrips> fromOptions = getFromOptions(
              context.read<HomeScreenBloc>().allAvailabletrips!,
            );

            final List<AllAvailabletrips> toOptions =
                selectedFromStation != null
                ? getToOptions(
                    trips: context.read<HomeScreenBloc>().allAvailabletrips!,
                    fromOption: selectedFromStation!, //selectedFromOption!,
                  )
                : [];

            return SingleChildScrollView(
  padding: const EdgeInsets.all(10.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 15),
        child: Text(
          "Highly Trusted Buses",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      
      // Wrap CustomSearchWidget to handle potential sizing issues
      Container(
        constraints: BoxConstraints(
          maxHeight: 300, // Prevent unbounded height
        ),
        child: CustomSearchWidget(
          fromOptions: fromOptions,
          toOptions: toOptions,
          allAvailabletrips: context.read<HomeScreenBloc>().allAvailabletrips!,
          fromController: fromController,
          toController: toController,
          selectedDate: selectedDate,
          onDateSelected: (DateTime date) {
            setState(() {
              selectedDate = date;
            });
          },
          onSwapTap: () {
            final tempText = fromController.text;
            fromController.text = toController.text;
            toController.text = tempText;

            final tempStation = selectedFromStation;
            selectedFromStation = selectedToStation;
            selectedToStation = tempStation;
            setState(() {}); // Refresh dropdowns

            print(
              "Swapped stations: ${selectedFromStation?.srcname} and ${selectedToStation?.srcname}",
            );
          },
          onSearchTap: () {
            if (selectedFromStation == null || selectedToStation == null) {
              ToastMessage().showErrorToast(
                "Please select both stations.",
              );
              return;
            }

            String dateSelected = DateFormat('yyyy-MM-dd').format(selectedDate);

            context.read<HomeScreenBloc>().add(
              SearchAvailableTripsEvent(
                from: selectedFromStation!.srcid!,
                to: selectedToStation!.srcid!,
                date: dateSelected,
              ),
            );
          },
          onFromSelected: (AllAvailabletrips allAvailabletrips) {
            selectedFromStation = allAvailabletrips;
            setState(() {}); // Rebuild so toOptions updates
          },
          onToSelected: (AllAvailabletrips station) {
            selectedToStation = station;
            print(
              "Selected To Station: ${selectedToStation?.srcname}",
            );
          },
        ),
      ),
      
      const SizedBox(height: 5),

      // Remove Expanded and use BlocProvider directly
      BlocProvider(
        create: (context) => TripPlannerBloc(repository: TripPlannerRepository()),
        child: TripPlannerWidget(),
      ),
    ],
  ),
);
          },
        ),
      ),
    );
  }
}
