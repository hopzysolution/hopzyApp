import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/commonWidgets/custom_action_button.dart';
import 'package:ridebooking/commonWidgets/station_search_view.dart';
import 'package:ridebooking/models/all_trip_data_model.dart';
// import 'package:ridebooking/models/station_model.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/globels.dart' as globals;
import '../../utils/utils.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onSwapTap;
  final VoidCallback onSearchTap;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<AllAvailabletrips> allAvailabletrips;
  final Function(AllAvailabletrips station) onFromSelected;
  final Function(AllAvailabletrips station) onToSelected;
  final List<AllAvailabletrips> fromOptions;
  final List<AllAvailabletrips> toOptions;

  const CustomSearchWidget({
    Key? key,
    required this.fromController,
    required this.toController,
    required this.onSwapTap,
    required this.onSearchTap,
    required this.selectedDate,
    required this.onDateSelected,
    required this.allAvailabletrips,
    required this.onToSelected,
    required this.onFromSelected,
    required this.fromOptions,
    required this.toOptions,
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
                    options: fromOptions,
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  _buildTextField(
                    context: context,
                    controller: toController,
                    icon: Icons.directions_bus,
                    hintText: 'To',
                    options: toOptions,
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
                    // Inside GestureDetector
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      globals.selectedDate = formatter.format(picked); // String now
                      onDateSelected(
                        picked,
                      ); // <-- this notifies the parent to update
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedDate),
                          style: const TextStyle(
                            fontSize: 12,
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
                  backgroundColor: Colors.white,
                  textColor: AppColors.neutral900,
                  onPressed: () {
                    globals.selectedDate = Utils.todaysDate();
                    onDateSelected(DateTime.now());
                  },
                  text: "Today",
                ),
              ),
              const SizedBox(width: 5),
              // Tomorrow Button
              Flexible(
                flex: 1,
                child: CustomActionButton(
                  backgroundColor: AppColors.primaryBlue,
                  onPressed: () {
                    globals.selectedDate = Utils.futureDate();
                    onDateSelected(DateTime.now().add(Duration(days: 1)));
                  },
                  text: "Tomorrow",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Button
          CustomActionButton(
            onPressed: onSearchTap,
            text: 'Hopein...',
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
    required List<AllAvailabletrips>? options,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
              ),
              onTap: () async {
                final selectedStation = await Navigator.push<AllAvailabletrips>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StationSearchView(allAvailabletripsList: options!),
                  ),
                );

                if (selectedStation != null) {
                  controller.text = selectedStation.srcname ?? '';
                  // You can also store selectedStation.stationId wherever needed
                  if (hintText.toLowerCase() == 'from') {
                    onFromSelected(selectedStation);
                  } else if (hintText.toLowerCase() == 'to') {
                    onToSelected(selectedStation);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
