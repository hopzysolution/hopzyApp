import 'package:flutter/material.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/utils/app_colors.dart';

class FilterRowView extends StatefulWidget {
  final List<Trips>? allTrips;
  final Function(List<Trips>) onFilterChanged;

  FilterRowView({Key? key, this.allTrips, required this.onFilterChanged})
    : super(key: key);

  @override
  State<FilterRowView> createState() => _FilterRowViewState();
}

class _FilterRowViewState extends State<FilterRowView> {
  // Filter states
  bool isACSelected = false;
  bool isSleeperSelected = false;
  bool isNonACSelected = false;

  // Time filter states - Shift-based filtering (Dec 10, 2025)
  bool isMorningSelected = false; // 6 AM - 12 PM
  bool isAfternoonSelected = false; // 12 PM - 6 PM
  bool isEveningSelected = false; // 6 PM - 12 AM
  bool isNightSelected = false; // 12 AM - 6 AM

  String _selectedTab = "Bus Type";

  // Sort state
  String? selectedSort;

  // Advanced filter states
  Set<String> selectedBusTypes = {};
  Set<String> selectedBoardingPoints = {};
  Set<String> selectedDroppingPoints = {};
  Set<String> selectedDepartureTimes = {};
  RangeValues selectedFareRange = const RangeValues(0, 2000);

  // Fare range bounds
  double minFare = 0;
  double maxFare = 2000;

  @override
  void initState() {
    super.initState();
    // Initialize with all trips
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
    });
  }

  // Helper methods for filter management
  Set<String> _getSelectedItems() {
    switch (_selectedTab) {
      case "Bus Type":
        return selectedBusTypes;
      case "Boarding":
        return selectedBoardingPoints;
      case "Dropping":
        return selectedDroppingPoints;
      case "Departure":
        return selectedDepartureTimes;
      default:
        return {};
    }
  }

  void _toggleSelection(String item) {
    Set<String> currentSelection = _getSelectedItems();
    if (currentSelection.contains(item)) {
      currentSelection.remove(item);
    } else {
      currentSelection.add(item);
    }
  }

  String _formatDepartureTime(String deptime) {
    try {
      DateTime dateTime = DateTime.parse(deptime);
      int hour = dateTime.hour;
      int minute = dateTime.minute;

      // Convert to 12-hour format with AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return deptime;
    }
  }

  // Helper to get shift name from departure time (Dec 10, 2025)
  String _getTimeShift(String deptime) {
    try {
      DateTime dateTime = DateTime.parse(deptime);
      int hour = dateTime.hour;

      if (hour >= 6 && hour < 12) return 'Morning (6 AM - 12 PM)';
      if (hour >= 12 && hour < 18) return 'Afternoon (12 PM - 6 PM)';
      if (hour >= 18 && hour < 24) return 'Evening (6 PM - 12 AM)';
      return 'Night (12 AM - 6 AM)';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Helper to get shift icon (Dec 10, 2025)
  Widget _getShiftIcon(String shift) {
    IconData icon;
    Color color;

    if (shift.contains('Morning')) {
      icon = Icons.wb_sunny;
      color = Colors.orange;
    } else if (shift.contains('Afternoon')) {
      icon = Icons.wb_twilight;
      color = Colors.deepOrange;
    } else if (shift.contains('Evening')) {
      icon = Icons.nights_stay;
      color = Colors.indigo;
    } else {
      icon = Icons.nightlight;
      color = Colors.deepPurple;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildFareRangeContent(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range: ₹${selectedFareRange.start.round()} - ₹${selectedFareRange.end.round()}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '₹${selectedFareRange.start.round()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        width: 150,
                        child: RangeSlider(
                          values: selectedFareRange,
                          min: minFare,
                          max: maxFare,
                          divisions: maxFare > minFare ? 20 : null,
                          activeColor: AppColors.primaryBlueDark,
                          inactiveColor: AppColors.primaryBlueDark.withOpacity(
                            0.3,
                          ),
                          labels: RangeLabels(
                            '₹${selectedFareRange.start.round()}',
                            '₹${selectedFareRange.end.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setModalState(() {
                              selectedFareRange = values;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '₹${selectedFareRange.end.round()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (widget.allTrips == null) return;

    List<Trips> filteredTrips = List.from(widget.allTrips!);

    // Apply bus type filters - Updated Dec 13, 2025 for category-based filtering
    if (isACSelected ||
        isSleeperSelected ||
        isNonACSelected ||
        selectedBusTypes.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        String busType = trip.bustype?.toLowerCase() ?? '';

        bool matchesQuickFilter = false;
        if (isACSelected &&
            busType.contains('ac') &&
            !busType.contains('non')) {
          matchesQuickFilter = true;
        }
        if (isSleeperSelected && busType.contains('sleeper')) {
          matchesQuickFilter = true;
        }
        if (isNonACSelected && busType.contains('non')) {
          matchesQuickFilter = true;
        }

        // NEW CODE (Dec 13, 2025 - Category-based bus type filtering)
        bool matchesAdvancedFilter = selectedBusTypes.isEmpty;

        if (selectedBusTypes.isNotEmpty) {
          for (String category in selectedBusTypes) {
            if (category == 'AC' &&
                busType.contains('ac') &&
                !busType.contains('non')) {
              matchesAdvancedFilter = true;
              break;
            }
            if (category == 'Non-AC' &&
                (busType.contains('non') || (!busType.contains('ac')))) {
              matchesAdvancedFilter = true;
              break;
            }
            if (category == 'Sleeper' &&
                busType.contains('sleeper') &&
                !busType.contains('seater')) {
              matchesAdvancedFilter = true;
              break;
            }
            if (category == 'Seater' &&
                busType.contains('seater') &&
                !busType.contains('sleeper')) {
              matchesAdvancedFilter = true;
              break;
            }
            if (category == 'Sleeper/Seater' &&
                busType.contains('sleeper') &&
                busType.contains('seater')) {
              matchesAdvancedFilter = true;
              break;
            }
          }
        } else {
          matchesAdvancedFilter = true;
        }

        return (isACSelected || isSleeperSelected || isNonACSelected)
            ? matchesQuickFilter
            : matchesAdvancedFilter;
      }).toList();
    }

    // Apply time filters - Shift-based filtering (Dec 10, 2025)
    if (isMorningSelected ||
        isAfternoonSelected ||
        isEveningSelected ||
        isNightSelected) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.deptime == null) return false;

        try {
          DateTime depTime = DateTime.parse(trip.deptime!);
          int hour = depTime.hour;

          if (isMorningSelected && hour >= 6 && hour < 12) return true;
          if (isAfternoonSelected && hour >= 12 && hour < 18) return true;
          if (isEveningSelected && hour >= 18 && hour < 24) return true;
          if (isNightSelected && hour >= 0 && hour < 6) return true;

          return false;
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Apply boarding point filter
    if (selectedBoardingPoints.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.boardingpoint?.bpDetails == null) return false;
        return trip.boardingpoint!.bpDetails!.any(
          (bp) =>
              selectedBoardingPoints.contains(bp.stnname) ||
              selectedBoardingPoints.contains(bp.venue),
        );
      }).toList();
    }

    // Apply dropping point filter
    if (selectedDroppingPoints.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.droppingpoint?.dpDetails == null) return false;
        return trip.droppingpoint!.dpDetails!.any(
          (dp) =>
              selectedDroppingPoints.contains(dp.stnname) ||
              selectedDroppingPoints.contains(dp.venue),
        );
      }).toList();
    }

    // Apply departure time filter - Updated to use shift-based filtering (Dec 10, 2025)
    if (selectedDepartureTimes.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.deptime == null) return false;

        try {
          DateTime depTime = DateTime.parse(trip.deptime!);
          int hour = depTime.hour;

          // Check if trip matches any selected shift
          for (String shift in selectedDepartureTimes) {
            if (shift == 'Morning (6 AM - 12 PM)' && hour >= 6 && hour < 12)
              return true;
            if (shift == 'Afternoon (12 PM - 6 PM)' && hour >= 12 && hour < 18)
              return true;
            if (shift == 'Evening (6 PM - 12 AM)' && hour >= 18 && hour < 24)
              return true;
            if (shift == 'Night (12 AM - 6 AM)' && hour >= 0 && hour < 6)
              return true;
          }
          return false;
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Apply fare range filter
    filteredTrips = filteredTrips.where((trip) {
      if (trip.fare == null) return false;
      double fare = double.tryParse(trip.fare!) ?? 0;
      return fare >= selectedFareRange.start && fare <= selectedFareRange.end;
    }).toList();

    // Apply sorting
    if (selectedSort != null) {
      switch (selectedSort) {
        case 'price_low':
          filteredTrips.sort((a, b) {
            double priceA = double.tryParse(a.fare ?? '0') ?? 0;
            double priceB = double.tryParse(b.fare ?? '0') ?? 0;
            return priceA.compareTo(priceB);
          });
          break;
        case 'price_high':
          filteredTrips.sort((a, b) {
            double priceA = double.tryParse(a.fare ?? '0') ?? 0;
            double priceB = double.tryParse(b.fare ?? '0') ?? 0;
            return priceB.compareTo(priceA);
          });
          break;
        case 'departure':
          filteredTrips.sort((a, b) {
            try {
              DateTime timeA = DateTime.parse(a.deptime ?? '');
              DateTime timeB = DateTime.parse(b.deptime ?? '');
              return timeA.compareTo(timeB);
            } catch (e) {
              return 0;
            }
          });
          break;
        case 'duration':
          filteredTrips.sort((a, b) {
            String durationA = a.traveltime ?? a.travelTime ?? '0';
            String durationB = b.traveltime ?? b.travelTime ?? '0';
            return durationA.compareTo(durationB);
          });
          break;
        case 'seats':
          filteredTrips.sort((a, b) {
            int seatsA = int.tryParse(a.availseats ?? '0') ?? 0;
            int seatsB = int.tryParse(b.availseats ?? '0') ?? 0;
            return seatsB.compareTo(seatsA);
          });
          break;
      }
    }

    widget.onFilterChanged(filteredTrips);
  }

  void _clearAllFilters() {
    setState(() {
      isACSelected = false;
      isSleeperSelected = false;
      isNonACSelected = false;
      isMorningSelected = false;
      isAfternoonSelected = false;
      isEveningSelected = false;
      isNightSelected = false;
      selectedSort = null;
      selectedBusTypes.clear();
      selectedBoardingPoints.clear();
      selectedDroppingPoints.clear();
      selectedDepartureTimes.clear();
      selectedFareRange = RangeValues(minFare, maxFare);
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            label: 'Filter',
            icon: Icons.filter_list,
            isSelected: false,
            onTap: () {
              _showFilterDialog();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Sort',
            icon: Icons.sort,
            isSelected: false,
            onTap: () {
              _showSortDialog();
            },
          ),
          // const SizedBox(width: 8),
          // _buildFilterChip(
          //   label: 'AC',
          //   isSelected: isACSelected,
          //   onTap: () {
          //     setState(() {
          //       isACSelected = !isACSelected;
          //     });
          //     _applyFilters();
          //   },
          // ),
          // const SizedBox(width: 8),
          // _buildFilterChip(
          //   label: 'Sleeper',
          //   isSelected: isSleeperSelected,
          //   onTap: () {
          //     setState(() {
          //       isSleeperSelected = !isSleeperSelected;
          //     });
          //     _applyFilters();
          //   },
          // ),
          // const SizedBox(width: 8),
          // _buildFilterChip(
          //   label: 'Non AC',
          //   isSelected: isNonACSelected,
          //   onTap: () {
          //     setState(() {
          //       isNonACSelected = !isNonACSelected;
          //     });
          //     _applyFilters();
          //   },
          // ),
          // const SizedBox(width: 8),
          // _buildFilterChip(
          //   label: 'Time',
          //   icon: Icons.access_time,
          //   isSelected:
          //       isMorningSelected ||
          //       isAfternoonSelected ||
          //       isEveningSelected ||
          //       isNightSelected,
          //   onTap: () {
          //     _showTimeFilterDialog();
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlueDark : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlueDark
                : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Departure Time Shift',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Select your preferred departure shift',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildTimeShiftCard(
                'Morning',
                '6:00 AM - 12:00 PM',
                Icons.wb_sunny,
                Colors.orange,
                isMorningSelected,
                (value) {
                  setModalState(() => isMorningSelected = value ?? false);
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildTimeShiftCard(
                'Afternoon',
                '12:00 PM - 6:00 PM',
                Icons.wb_twilight,
                Colors.deepOrange,
                isAfternoonSelected,
                (value) {
                  setModalState(() => isAfternoonSelected = value ?? false);
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildTimeShiftCard(
                'Evening',
                '6:00 PM - 12:00 AM',
                Icons.nights_stay,
                Colors.indigo,
                isEveningSelected,
                (value) {
                  setModalState(() => isEveningSelected = value ?? false);
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildTimeShiftCard(
                'Night',
                '12:00 AM - 6:00 AM',
                Icons.nightlight,
                Colors.deepPurple,
                isNightSelected,
                (value) {
                  setModalState(() => isNightSelected = value ?? false);
                },
                setModalState,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          isMorningSelected = false;
                          isAfternoonSelected = false;
                          isEveningSelected = false;
                          isNightSelected = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Update main state
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlueDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeShiftCard(
    String title,
    String time,
    IconData icon,
    Color color,
    bool isSelected,
    Function(bool?) onChanged,
    StateSetter setModalState,
  ) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(
    String title,
    String time,
    bool isSelected,
    Function(bool?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlueDark,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _showFilterDialog() {
  //   // Get unique bus types from all trips
  //   Set<String> busTypes = {};
  //   Set<String> boardingPoints = {};
  //   Set<String> droppingPoints = {};

  //   widget.allTrips?.forEach((trip) {
  //     if (trip.bustype != null) busTypes.add(trip.bustype!);
  //     trip.boardingpoint?.bpDetails?.forEach((bp) {
  //       if (bp.stnname != null) boardingPoints.add(bp.stnname!);
  //     });
  //     trip.droppingpoint?.dpDetails?.forEach((dp) {
  //       if (dp.stnname != null) droppingPoints.add(dp.stnname!);
  //     });
  //   });

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, setModalState) => Container(
  //         padding: const EdgeInsets.all(20),
  //         constraints: BoxConstraints(
  //           maxHeight: MediaQuery.of(context).size.height * 0.8,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Filters',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 20),
  //             Flexible(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     if (busTypes.isNotEmpty) ...[
  //                       _buildFilterOption(
  //                         'Bus Type',
  //                         busTypes.toList(),
  //                         selectedBusTypes,
  //                         setModalState,
  //                       ),
  //                       const Divider(),
  //                     ],
  //                     if (boardingPoints.isNotEmpty) ...[
  //                       _buildFilterOption(
  //                         'Boarding Point',
  //                         boardingPoints.toList(),
  //                         selectedBoardingPoints,
  //                         setModalState,
  //                       ),
  //                       const Divider(),
  //                     ],
  //                     if (droppingPoints.isNotEmpty) ...[
  //                       _buildFilterOption(
  //                         'Dropping Point',
  //                         droppingPoints.toList(),
  //                         selectedDroppingPoints,
  //                         setModalState,
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () {
  //                       setModalState(() {
  //                         selectedBusTypes.clear();
  //                         selectedBoardingPoints.clear();
  //                         selectedDroppingPoints.clear();
  //                       });
  //                       _clearAllFilters();
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text('Clear All'),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       setState(() {}); // Update main state
  //                       _applyFilters();
  //                       Navigator.pop(context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.red.shade600,
  //                     ),
  //                     child: const Text(
  //                       'Apply',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showFilterDialog() {
    // AUTO FETCHED FROM API
    Set<String> busTypes = {};
    Set<String> boardingPoints = {};
    Set<String> droppingPoints = {};
    Set<String> departureTimes = {};
    List<double> fares = [];

    widget.allTrips?.forEach((trip) {
      if (trip.bustype != null) busTypes.add(trip.bustype!);

      trip.boardingpoint?.bpDetails?.forEach((bp) {
        // Add both stnname and venue if they exist
        if (bp.stnname != null && bp.stnname!.isNotEmpty) {
          boardingPoints.add(bp.stnname!);
        }
        if (bp.venue != null && bp.venue!.isNotEmpty) {
          boardingPoints.add(bp.venue!);
        }
      });

      trip.droppingpoint?.dpDetails?.forEach((dp) {
        // Add both stnname and venue if they exist
        if (dp.stnname != null && dp.stnname!.isNotEmpty) {
          droppingPoints.add(dp.stnname!);
        }
        if (dp.venue != null && dp.venue!.isNotEmpty) {
          droppingPoints.add(dp.venue!);
        }
      });

      if (trip.deptime != null) departureTimes.add(trip.deptime!);

      if (trip.fare != null) {
        double? fare = double.tryParse(trip.fare!);
        if (fare != null) fares.add(fare);
      }
    });

    // Debug: Print collected points
    print('Boarding Points: ${boardingPoints.length} - $boardingPoints');
    print('Dropping Points: ${droppingPoints.length} - $droppingPoints');

    // Calculate fare range
    if (fares.isNotEmpty) {
      minFare = fares.reduce((a, b) => a < b ? a : b);
      maxFare = fares.reduce((a, b) => a > b ? a : b);
      if (selectedFareRange.start == 0 && selectedFareRange.end == 2000) {
        selectedFareRange = RangeValues(minFare, maxFare);
      }
    }

    List<String> _options() {
      if (_selectedTab == "Bus Type") {
        // Show standard bus type categories instead of API types
        return ['AC', 'Non-AC', 'Sleeper', 'Seater', 'Sleeper/Seater'];
      }
      if (_selectedTab == "Boarding") return boardingPoints.toList();
      if (_selectedTab == "Dropping") return droppingPoints.toList();
      if (_selectedTab == "Departure") {
        return [
          'Morning (6 AM - 12 PM)',
          'Afternoon (12 PM - 6 PM)',
          'Evening (6 PM - 12 AM)',
          'Night (12 AM - 6 AM)',
        ];
      }
      return [];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(18),
              height: MediaQuery.of(context).size.height * 0.58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Filter Buses",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          size: 28,
                          color: AppColors.primaryBlueDark,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT TAB PANEL
                        Container(
                          width: 130,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              _tabButton("Bus Type", setModalState),
                              SizedBox(height: 10),
                              _tabButton("Boarding", setModalState),
                              SizedBox(height: 10),
                              _tabButton("Dropping", setModalState),
                              SizedBox(height: 10),
                              _tabButton("Departure", setModalState),
                              SizedBox(height: 10),
                              _tabButton("Fare Range", setModalState),
                            ],
                          ),
                        ),

                        SizedBox(width: 16),

                        // RIGHT OPTIONS PANEL
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: _selectedTab == "Fare Range"
                                ? _buildFareRangeContent(setModalState)
                                : _options().isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No ${_selectedTab} options available',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView(
                                    children: _options().map((item) {
                                      bool selected = _getSelectedItems()
                                          .contains(item);

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: Icon(
                                            selected
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            size: 24,
                                            color: selected
                                                ? AppColors.primaryBlueDark
                                                : Colors.grey,
                                          ),
                                          onTap: () {
                                            setModalState(() {
                                              _toggleSelection(item);
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // RESET AND APPLY BUTTONS - Added on Dec 13, 2025
                  Row(
                    children: [
                      // Reset Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _clearAllFilters();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primaryBlueDark),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              color: AppColors.primaryBlueDark,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Apply Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlueDark,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Apply",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _leftTab(String title, String selectedTab, Function setState) {
    bool isSelected = selectedTab == title;

    return InkWell(
      onTap: () => setState(() => selectedTab = title),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlueDark : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlueDark.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, Function setModalState) {
    bool active = _selectedTab == title;

    return InkWell(
      onTap: () {
        setModalState(() {
          _selectedTab = title;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryBlueDark : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String title,
    List<String> options,
    Set<String> selected,
    StateSetter setModalState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: selected.contains(option),
                  onSelected: (isSelected) {
                    setModalState(() {
                      if (isSelected) {
                        selected.add(option);
                      } else {
                        selected.remove(option);
                      }
                    });
                  },
                  selectedColor: AppColors.primaryBlueDark.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryBlueDark,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(18),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Sort Buses",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: AppColors.primaryBlueDark,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // SORT OPTIONS
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListView(
                    children: [
                      _buildSortOption(
                        'Price (Low to High)',
                        Icons.arrow_upward,
                        'price_low',
                        setModalState,
                      ),
                      _buildSortOption(
                        'Price (High to Low)',
                        Icons.arrow_downward,
                        'price_high',
                        setModalState,
                      ),
                      _buildSortOption(
                        'Departure Time',
                        Icons.access_time,
                        'departure',
                        setModalState,
                      ),
                      _buildSortOption(
                        'Duration',
                        Icons.schedule,
                        'duration',
                        setModalState,
                      ),
                      _buildSortOption(
                        'Available Seats',
                        Icons.event_seat,
                        'seats',
                        setModalState,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),

              // RESET AND APPLY BUTTONS
              Row(
                children: [
                  // Reset Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          selectedSort = null;
                        });
                        setState(() {
                          selectedSort = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlueDark),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: AppColors.primaryBlueDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Apply Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlueDark,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    String title,
    IconData icon,
    String value,
    StateSetter setModalState,
  ) {
    bool selected = selectedSort == value;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? AppColors.primaryBlueDark : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          selected ? Icons.check_circle : Icons.circle_outlined,
          size: 24,
          color: selected ? AppColors.primaryBlueDark : Colors.grey,
        ),
        onTap: () {
          setModalState(() {
            selectedSort = value;
          });
        },
      ),
    );
  }
}
