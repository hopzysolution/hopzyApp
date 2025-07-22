import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc,HomeScreenState>(
      listener: (context,state){

      if(state is HomeScreenFailure){
        // Handle state changes if needed
        ToastMessage().showErrorToast(
           state.error,
        );
      }

    },
    child: BlocBuilder<HomeScreenBloc,HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeScreenLoaded) {
          // Handle the loaded state if needed
          return   Center(
            child: Text(
              'Stations Loaded: ${state.stations?.stationDetails!.length ?? 'No stations found'}',
              style: const TextStyle(fontSize: 20),
            ),
          );

        } else {
          return    Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CustomSearchWidget(
            fromController: fromController,
            toController: toController,
            onSwapTap: () {
              // Swap logic
              final temp = fromController.text;
              fromController.text = toController.text;
              toController.text = temp;
            },
            onSearchTap: () {
              // Search logic
            },
            onDateSelected: (DateTime date) {
              setState(() { // Update selected date
              });
            },
            
            selectedDate: DateTime.now(), // Pass the state-managed date
          ),
            Spacer()
          ],
        ),
      );
        }

        // Return the main UI of the HomeScreen
      
  
    }));
    
    
    
  
  }
}