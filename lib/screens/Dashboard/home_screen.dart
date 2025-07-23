import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_bloc.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_event.dart';
import 'package:ridebooking/bloc/homeScreenBloc/home_screen_state.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenBloc(), 
      child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeScreenFailure) {
            ToastMessage().showErrorToast(state.error);
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

            // Whether loaded or fallback, show the same base UI
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CustomSearchWidget(
                    stations: context.read<HomeScreenBloc>().stations!,
                    fromController: fromController,
                    toController: toController,
                    onSwapTap: () {
                      final temp = fromController.text;
                      fromController.text = toController.text;
                      toController.text = temp;
                    },
                    onSearchTap: () {
                      // Search logic (dispatch bloc event if needed)
                    },
                    onDateSelected: (DateTime date) {
                      setState(() {});
                    },
                    selectedDate: DateTime.now(),
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
