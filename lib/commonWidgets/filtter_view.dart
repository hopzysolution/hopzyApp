import 'package:flutter/material.dart';
import 'package:ridebooking/models/available_trip_data.dart';

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

  // Time filter states
  bool isEarlyMorningSelected = false;
  bool isMorningSelected = false;
  bool isAfternoonSelected = false;
  bool isEveningSelected = false;

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
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return deptime;
    }
  }

  Widget _buildFareRangeContent(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Fare Range',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Price Range: ₹${selectedFareRange.start.round()} - ₹${selectedFareRange.end.round()}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          RangeSlider(
            values: selectedFareRange,
            min: minFare,
            max: maxFare,
            divisions: maxFare > minFare ? 20 : null,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.3),
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${minFare.round()}'),
              Text('₹${maxFare.round()}'),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (widget.allTrips == null) return;

    List<Trips> filteredTrips = List.from(widget.allTrips!);

    // Apply bus type filters
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

        bool matchesAdvancedFilter =
            selectedBusTypes.isEmpty ||
            selectedBusTypes.any(
              (type) => busType.contains(type.toLowerCase()),
            );

        return (isACSelected || isSleeperSelected || isNonACSelected)
            ? matchesQuickFilter
            : matchesAdvancedFilter;
      }).toList();
    }

    // Apply time filters
    if (isEarlyMorningSelected ||
        isMorningSelected ||
        isAfternoonSelected ||
        isEveningSelected) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.deptime == null) return false;

        try {
          DateTime depTime = DateTime.parse(trip.deptime!);
          int hour = depTime.hour;

          if (isEarlyMorningSelected && hour >= 0 && hour < 6) return true;
          if (isMorningSelected && hour >= 6 && hour < 12) return true;
          if (isAfternoonSelected && hour >= 12 && hour < 18) return true;
          if (isEveningSelected && hour >= 18 && hour < 24) return true;

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

    // Apply departure time filter
    if (selectedDepartureTimes.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        if (trip.deptime == null) return false;
        return selectedDepartureTimes.contains(trip.deptime);
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
      isEarlyMorningSelected = false;
      isMorningSelected = false;
      isAfternoonSelected = false;
      isEveningSelected = false;
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
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
              isSelected: selectedSort != null,
              onTap: () {
                _showSortDialog();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'AC',
              isSelected: isACSelected,
              onTap: () {
                setState(() {
                  isACSelected = !isACSelected;
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Sleeper',
              isSelected: isSleeperSelected,
              onTap: () {
                setState(() {
                  isSleeperSelected = !isSleeperSelected;
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Non AC',
              isSelected: isNonACSelected,
              onTap: () {
                setState(() {
                  isNonACSelected = !isNonACSelected;
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Time',
              icon: Icons.access_time,
              isSelected:
                  isEarlyMorningSelected ||
                  isMorningSelected ||
                  isAfternoonSelected ||
                  isEveningSelected,
              onTap: () {
                _showTimeFilterDialog();
              },
            ),
          ],
        ),
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
          color: isSelected ? Colors.blue.shade600 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
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
              const Text(
                'Departure Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTimeSlot(
                'Early Morning',
                '12:00 AM - 6:00 AM',
                isEarlyMorningSelected,
                (value) {
                  setModalState(() => isEarlyMorningSelected = value ?? false);
                },
              ),
              _buildTimeSlot(
                'Morning',
                '6:00 AM - 12:00 PM',
                isMorningSelected,
                (value) {
                  setModalState(() => isMorningSelected = value ?? false);
                },
              ),
              _buildTimeSlot(
                'Afternoon',
                '12:00 PM - 6:00 PM',
                isAfternoonSelected,
                (value) {
                  setModalState(() => isAfternoonSelected = value ?? false);
                },
              ),
              _buildTimeSlot(
                'Evening',
                '6:00 PM - 12:00 AM',
                isEveningSelected,
                (value) {
                  setModalState(() => isEveningSelected = value ?? false);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Update main state
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
            activeColor: Colors.blue.shade600,
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
        if (bp.stnname != null) boardingPoints.add(bp.stnname!);
      });

      trip.droppingpoint?.dpDetails?.forEach((dp) {
        if (dp.stnname != null) droppingPoints.add(dp.stnname!);
      });

      if (trip.deptime != null) departureTimes.add(trip.deptime!);

      if (trip.fare != null) {
        double? fare = double.tryParse(trip.fare!);
        if (fare != null) fares.add(fare);
      }
    });

    // Calculate fare range
    if (fares.isNotEmpty) {
      minFare = fares.reduce((a, b) => a < b ? a : b);
      maxFare = fares.reduce((a, b) => a > b ? a : b);
      if (selectedFareRange.start == 0 && selectedFareRange.end == 2000) {
        selectedFareRange = RangeValues(minFare, maxFare);
      }
    }

    List<String> _options() {
      if (_selectedTab == "Bus Type") return busTypes.toList();
      if (_selectedTab == "Boarding") return boardingPoints.toList();
      if (_selectedTab == "Dropping") return droppingPoints.toList();
      if (_selectedTab == "Departure") return departureTimes.toList();
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
                      Text(
                        "Filter Buses",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: 28, color: Colors.blue),
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
                                            _selectedTab == "Departure"
                                                ? _formatDepartureTime(item)
                                                : item,
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
                                                ? Colors.blue
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

                  // APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
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
          color: active ? Colors.blue : Colors.grey.shade200,
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
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade600,
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
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Update main state
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
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
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: selectedSort,
        onChanged: (newValue) {
          setModalState(() {
            selectedSort = newValue;
          });
        },
        activeColor: Colors.blue.shade600,
      ),
      onTap: () {
        setModalState(() {
          selectedSort = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
