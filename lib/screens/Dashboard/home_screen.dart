import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
import 'package:ridebooking/models/station_model.dart';
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

  DateTime selectedDate = DateTime.now();

  StationDetails? selectedFromStation;
  StationDetails? selectedToStation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenBloc(),
      child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeScreenFailure) {
            ToastMessage().showErrorToast(state.error);
          }
           if(state is AllTripSuccessState){
              Navigator.pushNamed(context, Routes.availableTrips, arguments: state.allTrips);
            }
        },
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            if (state is HomeScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeScreenFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

           

            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CustomSearchWidget(
                    stations: context.read<HomeScreenBloc>().stations!,
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
                      print("Swapped stations: ${selectedFromStation?.station} and ${selectedToStation?.station}");
                    },
                    onSearchTap: () {
                      print("Searching for trips from ${fromController.text} to ${selectedToStation?.station} on $selectedDate");
                      if (selectedFromStation == null ||
                          selectedToStation == null) {
                        ToastMessage().showErrorToast("Please select both stations.");
                        return;
                      }
                      String dateSelected=DateFormat('yyyy-MM-dd').format(selectedDate);
                      context.read<HomeScreenBloc>().add(
                            SearchAvailableTripsEvent(
                              from: selectedFromStation!.stationId!,
                              to: selectedToStation!.stationId!,
                              date: dateSelected,
                            ),
                          );
                    },
                    onFromSelected: (StationDetails station) {

                      selectedFromStation = station;
                      print( "Selected From Station: ${selectedFromStation?.station}");
                   
                    },
                    onToSelected: (StationDetails station) {
                      selectedToStation = station;
                      print("Selected To Station: ${selectedToStation?.station}");
                    },
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
