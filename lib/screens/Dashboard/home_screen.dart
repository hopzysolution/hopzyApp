// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
// import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
// import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
// import 'package:ridebooking/bloc/station_bloc/all_station_bloc.dart';
// import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_bloc.dart';
// import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_repository.dart';
// import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
// import 'package:ridebooking/models/all_trip_data_model.dart';
// import 'package:ridebooking/models/operator_list_model.dart';
// import 'package:ridebooking/screens/trip_planner.dart';
// import 'package:ridebooking/shimmerView/bus_search_shimmer.dart';
// import 'package:ridebooking/utils/route_generate.dart';
// import 'package:ridebooking/utils/toast_messages.dart';
// import 'package:ridebooking/globels.dart' as globals;
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//
//   DateTime selectedDate = DateTime.now(); //DateTime.now();
//
//   City? selectedFromStation;
//   City? selectedToStation;
//
//
//
//   List<AllAvailabletrips> getFromOptions(List<AllAvailabletrips> trips) {
//     final Map<String, AllAvailabletrips> unique = {};
//     for (var trip in trips) {
//       if (trip.srcid != null && !unique.containsKey(trip.srcid)) {
//         unique[trip.srcid!] = AllAvailabletrips(
//           srcname: trip.srcname ?? "",
//           srcid: trip.srcid ?? "",
//           routeid: trip.routeid ?? "",
//         );
//       }
//     }
//     return unique.values.toList();
//   }
//
//
// //   List<AllAvailabletrips> getFromOptions(List<AllAvailabletrips> trips) {
// //   final Map<String, AllAvailabletrips> unique = {};
//
// //   for (var trip in trips) {
// //     if (trip.srcid != null && !unique.containsKey(trip.srcid)) {
// //       unique[trip.srcid!] = AllAvailabletrips(
// //         srcname: trip.srcname ?? "",
// //         srcid: trip.srcid!,
// //         routeid: trip.routeid,
// //       );
// //     }
// //   }
//
// //   return unique.values.toList();
// // }
//
//
//
//
//   List<AllAvailabletrips> getToOptions({
//     required List<AllAvailabletrips> trips,
//     required AllAvailabletrips fromOption,
//   }) {
//     final Map<String, AllAvailabletrips> uniqueDstMap = {};
//
//     final filtered = trips.where(
//       (trip) =>
//           trip.routeid == fromOption.routeid && trip.srcid == fromOption.srcid,
//     );
//     for (var trip in filtered) {
//       // print("--------getToOptions===${trip.toJson()}");
//       if (trip.dstid != null && !uniqueDstMap.containsKey(trip.dstid)) {
//         uniqueDstMap[trip.dstid!] = AllAvailabletrips(
//           ////////////
//           dstname: trip.srcname ?? "", //check this
//           dstid: trip.srcid ?? "",
//           srcid: trip.dstid,
//           srcname: trip.dstname ?? "",
//           ////////////
//           arrivaltime: trip.arrivaltime,
//           availseats: trip.availseats,
//           bustype: trip.bustype,
//           depaturetime: trip.depaturetime,
//           operatorid: trip.operatorid,
//           operatorname: trip.operatorname,
//           routeid: trip.routeid,
//           subtripid: trip.subtripid,
//           totalseats: trip.totalseats,
//           tripid: trip.tripid,
//           tripidV2: trip.tripidV2,
//         );
//       }
//     }
//
//     return uniqueDstMap.values.toList();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //  saveSelectedSeat();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => HomeScreenBloc(),
//       child: BlocListener<HomeScreenBloc, HomeScreenState>(
//         listener: (context, state) {
//           if (state is HomeScreenFailure) {
//             ToastMessage().showErrorToast(state.error);
//           }
//           if (state is AllTripSuccessState) {
//
//             Navigator.pushNamed(
//               context,
//               Routes.availableTrips,
//               arguments: {'allTrips': state.allTrips,
//                           'from': selectedFromStation!,
//                           'to': selectedToStation!,
//                           'opid':"VGT"//selectedToStation!.operatorid
//                           },
//             );
//
//           }
//         },
//         child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
//           builder: (context, state) {
//             if (state is HomeScreenLoading || state is HomeScreenInitial) {
//               return BusSearchShimmer(); //const Center(child: CircularProgressIndicator());
//             }
//
//
//
//             // if (state is HomeScreenFailure) {
//             //   return Center(
//             //     child: Text(
//             //       state.error,
//             //       style: const TextStyle(color: Colors.red, fontSize: 16),
//             //     ),
//             //   );
//             // }
//
//             // final List<AllAvailabletrips> fromOptions = getFromOptions(
//             //   context.read<HomeScreenBloc>().allAvailabletrips!,
//             // );
//
//             // final List<AllAvailabletrips> toOptions =
//             //     selectedFromStation != null
//             //     ? getToOptions(
//             //         trips: context.read<HomeScreenBloc>().allAvailabletrips!,
//             //         fromOption: selectedFromStation!, //selectedFromOption!,
//             //       )
//             //     : [];
//
//             return SingleChildScrollView(
//   padding: const EdgeInsets.all(10.0),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         padding: EdgeInsets.only(top: 10, bottom: 15),
//         child: Text(
//           "Highly Trusted Buses",
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//
//       // Wrap CustomSearchWidget to handle potential sizing issues
//       Container(
//         constraints: BoxConstraints(
//           maxHeight: 300, // Prevent unbounded height
//         ),
//         child: CustomSearchWidget(
//             fromController: fromController,
//             toController: toController,
//             selectedDate: selectedDate,
//             onDateSelected: (DateTime date) {
//               setState(() {
//                 selectedDate = date;
//               });
//             },
//             onSwapTap: () {
//               final tempText = fromController.text;
//               fromController.text = toController.text;
//               toController.text = tempText;
//
//               final tempStation = selectedFromStation;
//               selectedFromStation = selectedToStation;
//               selectedToStation = tempStation;
//               setState(() {});
//             },
//             onSearchTap: () {
//               if (selectedFromStation == null || selectedToStation == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Please select both stations.'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//                 return;
//               }
//
//               String dateSelected = DateFormat('yyyy-MM-dd').format(selectedDate);
//               context.read<HomeScreenBloc>().add(
//                 SearchAvailableTripsEvent(
//                   src: selectedFromStation!,
//                   dst: selectedToStation!,
//                   date: dateSelected,
//                 ),
//               );
//             },
//             onFromSelected: (City station) {
//               selectedFromStation = station;
//               setState(() {});
//             },
//             onToSelected: (City station) {
//               selectedToStation = station;
//               setState(() {});
//             },
//           ),
//
//
//       ),
//
//       const SizedBox(height: 5),
//
//       // Remove Expanded and use BlocProvider directly
//       BlocProvider(
//         create: (context) => TripPlannerBloc(repository: TripPlannerRepository()),
//         child: TripPlannerWidget(),
//       ),
//     ],
//   ),
// );
//           },
//         ),
//       ),
//     );
//   }
// }


///New Design
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/bloc/station_bloc/all_station_bloc.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_bloc.dart';
import 'package:ridebooking/bloc/trip_plan_bloc/trip_planner_repository.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
import 'package:ridebooking/models/operator_list_model.dart';
import 'package:ridebooking/screens/trip_planner.dart';
import 'package:ridebooking/shimmerView/bus_search_shimmer.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/toast_messages.dart';
import 'package:ridebooking/globels.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  City? selectedFromStation;
  City? selectedToStation;


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
      if (trip.dstid != null && !uniqueDstMap.containsKey(trip.dstid)) {
        uniqueDstMap[trip.dstid!] = AllAvailabletrips(
          dstname: trip.srcname ?? "",
          dstid: trip.srcid ?? "",
          srcid: trip.dstid,
          srcname: trip.dstname ?? "",
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    final isTablet = size.width > 600;
    final isDesktop = size.width > 900;

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
              arguments: {
                'allTrips': state.allTrips,
                'from': selectedFromStation!,
                'to': selectedToStation!,
                'opid': "VGT"
              },
            );
          }
        },
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            if (state is HomeScreenLoading || state is HomeScreenInitial) {
              return BusSearchShimmer();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Container
                      Container(
                        height: size.height * 0.3,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      //overlay without search box

                      Positioned(

                        left: 16,
                        right: 16,
                        child:  // Search Widget
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchWidget(
                            fromController: fromController,
                            toController: toController,
                            selectedDate: selectedDate,
                            onDateSelected: (DateTime date) {
                              setState(() => selectedDate = date);
                            },
                            onSwapTap: () {
                              final tempText = fromController.text;
                              fromController.text = toController.text;
                              toController.text = tempText;

                              final tempStation = selectedFromStation;
                              selectedFromStation = selectedToStation;
                              selectedToStation = tempStation;

                              setState(() {});
                            },
                            onSearchTap: () {
                              if (selectedFromStation == null ||
                                  selectedToStation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Please select both stations.',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    backgroundColor: Colors.red.shade400,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                                return;
                              }

                              String dateSelected =
                              DateFormat('yyyy-MM-dd').format(selectedDate);

                              context.read<HomeScreenBloc>().add(
                                SearchAvailableTripsEvent(
                                  src: selectedFromStation!,
                                  dst: selectedToStation!,
                                  date: dateSelected,
                                ),
                              );
                            },
                            onFromSelected: (City station) {
                              selectedFromStation = station;

                              setState(() {});
                            },
                            onToSelected: (City station) {
                              selectedToStation = station;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      // Overlay Search Box with search trip
                      // Positioned(
                      //
                      //   left: 16,
                      //   right: 16,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(24),
                      //     child: Container(
                      //       padding: EdgeInsets.all(isTablet ? 24 : 16),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(24),
                      //         boxShadow: const [
                      //           BoxShadow(
                      //             blurRadius: 12,
                      //             spreadRadius: 1,
                      //             offset: Offset(0, 5),
                      //             color: Colors.black26,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //
                      //           // Title Row
                      //           Row(
                      //             children: [
                      //               Container(
                      //                 padding: const EdgeInsets.all(8),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.blue.shade50,
                      //                   borderRadius: BorderRadius.circular(10),
                      //                 ),
                      //                 child: Icon(
                      //                   Icons.search_rounded,
                      //                   color: Colors.blue.shade700,
                      //                   size: 20,
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 12),
                      //               Text(
                      //                 "Search Your Trip",
                      //                 style: TextStyle(
                      //                   fontSize: isTablet ? 20 : 18,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: AppColors.primaryBlue,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //
                      //           const SizedBox(height: 20),
                      //
                      //           // Search Widget
                      //           CustomSearchWidget(
                      //             fromController: fromController,
                      //             toController: toController,
                      //             selectedDate: selectedDate,
                      //             onDateSelected: (DateTime date) {
                      //               setState(() => selectedDate = date);
                      //             },
                      //             onSwapTap: () {
                      //               final tempText = fromController.text;
                      //               fromController.text = toController.text;
                      //               toController.text = tempText;
                      //
                      //               final tempStation = selectedFromStation;
                      //               selectedFromStation = selectedToStation;
                      //               selectedToStation = tempStation;
                      //
                      //               setState(() {});
                      //             },
                      //             onSearchTap: () {
                      //               if (selectedFromStation == null ||
                      //                   selectedToStation == null) {
                      //                 ScaffoldMessenger.of(context).showSnackBar(
                      //                   SnackBar(
                      //                     content: const Text(
                      //                       'Please select both stations.',
                      //                       style: TextStyle(fontWeight: FontWeight.w500),
                      //                     ),
                      //                     backgroundColor: Colors.red.shade400,
                      //                     behavior: SnackBarBehavior.floating,
                      //                     shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(12),
                      //                     ),
                      //                     margin: const EdgeInsets.all(16),
                      //                   ),
                      //                 );
                      //                 return;
                      //               }
                      //
                      //               String dateSelected =
                      //               DateFormat('yyyy-MM-dd').format(selectedDate);
                      //
                      //               context.read<HomeScreenBloc>().add(
                      //                 SearchAvailableTripsEvent(
                      //                   src: selectedFromStation!,
                      //                   dst: selectedToStation!,
                      //                   date: dateSelected,
                      //                 ),
                      //               );
                      //             },
                      //             onFromSelected: (City station) {
                      //               selectedFromStation = station;
                      //               setState(() {});
                      //             },
                      //             onToSelected: (City station) {
                      //               selectedToStation = station;
                      //               setState(() {});
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Trip Planner Section

                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 24 : 16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.blue.shade50.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                            spreadRadius: -4,
                          ),
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: -2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blue.shade100.withOpacity(0.5),
                          width: 5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 28 : 20),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isTablet ? 12 : 10),
                                    decoration: BoxDecoration(
                                      
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.blue.shade400,
                                          Colors.blue.shade600,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.route_rounded,
                                      color: Colors.white,
                                      size: isTablet ? 24 : 22,
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 16 : 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Plan Your Journey",
                                          style: TextStyle(
                                            fontSize: isTablet ? 22 : 19,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue.shade900,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Find the best route for your trip",
                                          style: TextStyle(
                                            fontSize: isTablet ? 13 : 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue.shade600,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              BlocProvider(
                                create: (context) => TripPlannerBloc(
                                  repository: TripPlannerRepository(),
                                ),
                                child: TripPlannerWidget(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}