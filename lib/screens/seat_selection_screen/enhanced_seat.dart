// Enhanced Bottom Sheet Widget
import 'dart:ui';
import 'package:flutter/material.dart';

// You'll need to import your BusInfo class or define it here
class BusInfo {
  final String name;
  final String operator;
  final String route;
  final String time;
  final String date;
  final double rating;
  final String busType;
  final String coSaving;

  BusInfo({
    required this.name,
    required this.operator,
    required this.route,
    required this.time,
    required this.date,
    required this.rating,
    required this.busType,
    required this.coSaving,
  });
}

class EnhancedBusInfoBottomSheet extends StatefulWidget {
  final BusInfo busInfo;
  final Set<String>? selectedSeats;
  final ScrollController? scrollController;

  const EnhancedBusInfoBottomSheet(
      {Key? key,
      required this.busInfo,
      this.selectedSeats,
      this.scrollController})
      : super(key: key);

  @override
  _EnhancedBusInfoBottomSheetState createState() =>
      _EnhancedBusInfoBottomSheetState();
}

class _EnhancedBusInfoBottomSheetState
    extends State<EnhancedBusInfoBottomSheet> {
  int selectedTabIndex = 0;
  final List<String> tabs = [
    'Rate & Reviews',
    'Bus route',
    'Boarding',
    'Dropping',
    'Passengers'
  ];

  @override
  Widget build(BuildContext context) {
    print("-------abc------selected--${widget.selectedSeats}");
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bus info header
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.directions_bus, size: 30),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.busInfo.busType,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.busInfo.coSaving}% CO₂ saving',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Operator info
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.busInfo.operator,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${widget.busInfo.time} • ${widget.busInfo.date}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 12),
                            SizedBox(width: 2),
                            Text(
                              widget.busInfo.rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                  // Tab navigation
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedTabIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.red[50]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected ? Colors.red : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.red : Colors.grey[600],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tab content
                  _buildTabContent(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Continue button
          widget.selectedSeats!.isEmpty
              ? Container()
              // : Container(
              //     padding: EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1),
              //           blurRadius: 8,
              //           offset: Offset(0, -2),
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Text(
              //                 '${widget.selectedSeats!.length} seat(s) selected',
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               Text(
              //                 'Seats: ${widget.selectedSeats!.join(", ")}',
              //                 style: TextStyle(
              //                   color: Colors.grey.shade600,
              //                   fontSize: 14,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         ElevatedButton(
              //           onPressed: () {},
              //           // style: ElevatedButton.styleFrom(
              //           //   backgroundColor: Colors.red,
              //           //   shape: RoundedRectangleBorder(
              //           //     borderRadius: BorderRadius.circular(25),
              //           //   ),
              //           // ),
              //           child: Text(
              //             'Continue',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              : Container(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // Rate & Reviews
        return _buildRateReviewsTab();
      case 1: // Bus route
        return _buildBusRouteTab();
      case 2: // Boarding
        return _buildBoardingTab();
      case 3: // Dropping
        return _buildDroppingTab();
      case 4: // Passengers
        return _buildPassengersTab();
      default:
        return Container();
    }
  }

  Widget _buildRateReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Bus Highlights',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black87,
        //   ),
        // ),
        // SizedBox(height: 16),
        // _buildHighlightItem(Icons.wifi, 'Free WiFi'),
        // _buildHighlightItem(Icons.ac_unit, 'AC'),
        // _buildHighlightItem(Icons.charging_station, 'Charging Point'),
        // _buildHighlightItem(Icons.water_drop, 'Water Bottle'),
        // _buildHighlightItem(Icons.local_movies, 'Entertainment'),
        // SizedBox(height: 20),
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        _buildReviewItem('Great service and comfortable seats!', 5, 'John D.'),
        _buildReviewItem('Good bus, arrived on time', 4, 'Sarah M.'),
        _buildReviewItem('Clean and well maintained', 5, 'Mike R.'),
      ],
    );
  }

  Widget _buildBusRouteTab() {
    return Column(
      children: [
        _buildRouteItem('Dewas', '07:25', true),
        _buildRouteConnector(),
        _buildRouteItem('Indore Junction', '08:15', false),
        _buildRouteConnector(),
        _buildRouteItem('Ujjain', '09:00', false),
        _buildRouteConnector(),
        _buildRouteItem('Bhopal', '10:05', true),
      ],
    );
  }

  Widget _buildBoardingTab() {
    return Column(
      children: [
        _buildBoardingPoint('Dewas Bus Stand', '07:25', 'Main pickup point'),
        _buildBoardingPoint(
            'Dewas Railway Station', '07:30', 'Alternative pickup'),
      ],
    );
  }

  Widget _buildDroppingTab() {
    return Column(
      children: [
        _buildDroppingPoint(
            'Bhopal Railway Station', '10:00', 'Main drop point'),
        _buildDroppingPoint('Bhopal Bus Stand', '10:05', 'Final destination'),
      ],
    );
  }

  Widget _buildPassengersTab() {
    return Column(
      children: [
        _buildPassengerInfo('Total Seats', '40'),
        _buildPassengerInfo('Available', '15'),
        _buildPassengerInfo('Booked', '25'),
        _buildPassengerInfo('Female Only', '8'),
        _buildPassengerInfo('Male Only', '2'),
      ],
    );
  }

  Widget _buildHighlightItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String review, int rating, String reviewer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reviewer,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < rating ? Colors.orange : Colors.grey[300],
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            review,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteItem(String location, String time, bool isEndPoint) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isEndPoint ? Colors.red : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteConnector() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 8, bottom: 8),
      width: 2,
      height: 30,
      color: Colors.grey[300],
    );
  }

  Widget _buildBoardingPoint(String location, String time, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDroppingPoint(String location, String time, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}