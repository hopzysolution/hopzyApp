import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/commonWidgets/custom_action_button.dart';
import 'package:ridebooking/commonWidgets/station_search_view.dart';
import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/utils/app_colors.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onSwapTap;
  final VoidCallback onSearchTap;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<StationDetails> stations; 

  const CustomSearchWidget({
    Key? key,
    required this.fromController,
    required this.toController,
    required this.onSwapTap,
    required this.onSearchTap,
    required this.selectedDate,
    required this.onDateSelected,
    required this.stations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral400, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From & To Fields with Swap Button
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  _buildTextField(
                    context: context,
                    controller: fromController,
                    icon: Icons.directions_bus,
                    hintText: 'From',
                    
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  _buildTextField(
                    context: context,
                    controller: toController,
                    icon: Icons.directions_bus,
                    hintText: 'To',
                  ),
                ],
              ),
              Positioned(
                right: 3,
                top: 40,
                child: GestureDetector(
                  onTap: onSwapTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Date Picker Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Date Picker Button
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryBlue,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      onDateSelected(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedDate),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              // Today Button
              Flexible(
                flex: 1,
                child: CustomActionButton(
                  borderColor: AppColors.primaryBlue,
                  backgroundColor: AppColors.primaryBlueAccent.withOpacity(0.6),
                  textColor: AppColors.neutral900,
                  onPressed: () => onDateSelected(DateTime.now()), 
                  text: "Todays",
                  )
              ),
              const SizedBox(width: 5),
              // Tomorrow Button
              Flexible(
                flex: 1,
                child: CustomActionButton(
                  backgroundColor: AppColors.primaryBlue,
                  onPressed: () => onDateSelected(DateTime.now().add( Duration(days: 1))), 
                  text: "Tomorrow",
                  )
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Button
           CustomActionButton(
  onPressed: onSearchTap,
  text: 'Search',
  icon: Icons.search,
),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
                
              ),
               onTap: () async {
                // Navigate to LocationSearchView and wait for result
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationSearchView(
                      stationList: stations, // Pass the list of stations
                    ),
                  ),
                );
                // Update controller if a location is selected
                if (selectedLocation != null) {
                  controller.text = selectedLocation as String;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}