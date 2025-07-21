import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridebooking/commonWidgets/custom_search_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Container(
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
}