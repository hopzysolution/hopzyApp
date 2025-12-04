import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/station_bloc/all_station_event.dart';
import 'package:ridebooking/commonWidgets/custom_action_button.dart';
import 'package:ridebooking/bloc/station_bloc/all_station_bloc.dart';
import 'package:ridebooking/models/operator_list_model.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/globels.dart' as globals;
import '../../utils/utils.dart';
import 'station_search_dialog.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onSwapTap;
  final VoidCallback onSearchTap;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(City station) onFromSelected;
  final Function(City station) onToSelected;

  const CustomSearchWidget({
    Key? key,
    required this.fromController,
    required this.toController,
    required this.onSwapTap,
    required this.onSearchTap,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onToSelected,
    required this.onFromSelected,
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
                    searchType: 'src',
                    onStationSelected: onFromSelected,
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  _buildTextField(
                    context: context,
                    controller: toController,
                    icon: Icons.directions_bus,
                    hintText: 'To',
                    searchType: 'dst',
                    onStationSelected: onToSelected,
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
                    decoration: BoxDecoration(
                      color: AppColors.accent,
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
          //Old
          // Date Picker Row
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     // Date Picker Button
          //     Expanded(
          //       child: GestureDetector(
          //         onTap: () async {
          //           final DateTime? picked = await showDatePicker(
          //             context: context,
          //             initialDate: selectedDate,
          //             firstDate: DateTime.now(),
          //             lastDate: DateTime.now().add(const Duration(days: 30)),
          //           );
          //           if (picked != null) {
          //             final DateFormat formatter = DateFormat('yyyy-MM-dd');
          //             globals.selectedDate = formatter.format(picked);
          //             onDateSelected(picked);
          //           }
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 8,
          //             vertical: 10,
          //           ),
          //           decoration: BoxDecoration(
          //             border: Border.all(color: Colors.grey.shade300),
          //             borderRadius: BorderRadius.circular(8),
          //             color: Colors.grey.shade100,
          //           ),
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.calendar_today,
          //                 color: AppColors.vibrent,
          //                 size: 12,
          //               ),
          //               const SizedBox(width: 8),
          //               Text(
          //                 DateFormat('dd MMM yyyy').format(selectedDate),
          //                 style: const TextStyle(
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.w500,
          //                   color: AppColors.primaryBlue,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 5),
          //     // Today Button
          //     Flexible(
          //       flex: 1,
          //       child: CustomActionButton(
          //         borderColor: AppColors.primaryBlue,
          //         backgroundColor: Colors.white,
          //         textColor: AppColors.neutral900,
          //         onPressed: () {
          //           globals.selectedDate = Utils.todaysDate();
          //           onDateSelected(DateTime.now());
          //         },
          //         text: "Today",
          //       ),
          //     ),
          //     const SizedBox(width: 5),
          //     // Tomorrow Button
          //     Flexible(
          //       flex: 1,
          //       child: CustomActionButton(
          //         borderColor: AppColors.primaryBlue,
          //         backgroundColor: Colors.white,
          //         textColor: AppColors.neutral900,
          //         onPressed: () {
          //           globals.selectedDate = Utils.futureDate();
          //           onDateSelected(DateTime.now().add(Duration(days: 1)));
          //         },
          //         text: "Tomorrow",
          //       ),
          //     ),
          //   ],
          // ),
          //new
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const int daysCount = 6; // at least 6 dates
                    const double monthBoxWidth = 70;

                    // start strip from the selected date
                    final now = DateTime.now();
                    final DateTime baseDate = DateTime(
                      now.year,
                      now.month,
                      now.day,
                    );

                    bool isSameDay(DateTime a, DateTime b) =>
                        a.year == b.year && a.month == b.month && a.day == b.day;

                    final double itemWidth =
                        (constraints.maxWidth - monthBoxWidth - 8) / daysCount;

                    return Row(
                      children: [
                        // 6 date items
                        ...List.generate(daysCount, (index) {
                          final DateTime date = baseDate.add(Duration(days: index));
                          final bool isSelected = isSameDay(date, selectedDate);

                          return SizedBox(
                            width: itemWidth,
                            child: GestureDetector(
                              onTap: () {
                                final formatter = DateFormat('yyyy-MM-dd');
                                globals.selectedDate = formatter.format(date);
                                onDateSelected(date);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // date in circle
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.vibrent : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      DateFormat('dd').format(date),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // day below (FRI, SAT…)
                                  Text(
                                    DateFormat('EEE').format(date).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(width: 4),

                        // Month + Year button (opens calendar)
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (picked != null) {
                              final formatter = DateFormat('yyyy-MM-dd');
                              globals.selectedDate = formatter.format(picked);
                              onDateSelected(picked);
                            }
                          },
                          child: Container(
                            width: monthBoxWidth,
                            padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('MMM').format(selectedDate).toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy').format(selectedDate),
                                  style: const TextStyle(
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          // Search Button
          CustomActionButton(
            onPressed: onSearchTap,
            text: 'Hop in...',
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
    required String searchType,
    required Function(City) onStationSelected,
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
              readOnly: true,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade900),
                border: InputBorder.none,
                filled: true,
                // fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: Colors.grey.shade300),
                // ),
                enabledBorder:InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
              ),
              onTap: () async {
                // Create a new instance of AllStationBloc for the dialog
                // final stationBloc = AllStationBloc();



                final selectedStation = await showDialog<City>(
                  context: context,
                  builder: (dialogContext) => BlocProvider<AllStationBloc>(
                    create: (context) => AllStationBloc(),
                    child: StationSearchDialog(
                      searchType: searchType,
                      title: 'Select $hintText Station',
                    ),
                  ),
                );

                // Close the bloc after dialog is dismissed


                if (selectedStation != null) {
                  controller.text = selectedStation.cityName ?? '';
                  print("Selected Station: ${selectedStation.cityName}");
                  onStationSelected(selectedStation);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}