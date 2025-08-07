
import 'package:flutter/material.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_sizes.dart';

class TravelerInfoCard extends StatefulWidget {
  final String boardingInfo;
  final String boardingPoint;
  final String droppingInfo;
  final String droppingPoint;
  final Availabletrips tripData;
  final Set<SeatModell> seatDetails;

  const TravelerInfoCard({
    super.key,
    required this.boardingInfo,
    required this.boardingPoint,
    required this.droppingInfo,
    required this.droppingPoint,
    required this.tripData,
    required this.seatDetails,
  });

  @override
  State<TravelerInfoCard> createState() => _TravelerInfoCardState();
}

class _TravelerInfoCardState extends State<TravelerInfoCard> {

  @override
  void initState() {
    // TODO: implement initState

    listOFSTring();
    super.initState();
  }
List<String> noOfSeats=[];
listOFSTring(){
widget.seatDetails.map((e){
return noOfSeats.add(e.seatNo.toString());
}).toList();
}


  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) => SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar for dragging
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with title and cancel button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Booking Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Traveler name
                Text(
                  "Vagaai Travels", // Replace with your dynamic traveler name
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 16),

                // Seat details row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _seatDetailItem(
                          "Seat No", noOfSeats.toString()), // Replace with dynamic data
                      const SizedBox(width: 16),
                      _seatDetailItem("Type", widget.tripData.bustype!),
                      // const SizedBox(width: 16),
                      // _seatDetailItem("AC/Non-AC", widget.tripData.bustype!),
                      const SizedBox(width: 16),
                      _seatDetailItem("Qty", widget.seatDetails.length.toString()),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Boarding and Dropping section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Boarding section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Boarding Points",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.boardingPoint, // Your dynamic boarding point
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.boardingInfo, // Your dynamic boarding info
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Dropping section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Dropping Points",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.droppingPoint, // Your dynamic dropping point
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.droppingInfo, // Your dynamic dropping info
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Divider
                Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 16),

                // Seats details heading
                 Text(
                  "Amenities ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // const SizedBox(height: 8),

                // // Number of seats
                Text(
                  "${widget.tripData.amenities}.", // Dynamic seat count
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                // const SizedBox(height: 12),

                // // Seats list (horizontal scrollable)
                // Container(
                //   height: 40, // Increased height for better touch target
                //   child: ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: seatDetails.length,
                //     separatorBuilder: (context, index) =>
                //         const SizedBox(width: 8),
                //     itemBuilder: (context, index) {
                //       final seat = seatDetails[index];
                //       return _seatContainer(
                //           seat, "Sleeper"); // Replace "Sleeper" if needed
                //     },
                //   ),
                // ),

                // const SizedBox(height: 20), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper widget for seat detail items
  Widget _seatDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

// Helper widget for individual seat containers
  Widget _seatContainer(String seatName, String seatType) {
    return Container(
      // width: 100,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            seatName,
            style: const TextStyle(
              fontSize: AppSizes.xs,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            seatType,
            style: TextStyle(
              fontSize: AppSizes.xs,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getTripData
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // const Icon(
                //   Icons.account_circle,
                //   color: Colors.blue,
                //   size: 20,
                // ),
                // const SizedBox(width: 8),
                const Text(
                  "Vagaai Travels",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _infoColumn(
                      widget.boardingInfo,
                      widget.boardingPoint,
                      alignment: CrossAxisAlignment.start,
                      icon: Icons.trip_origin,
                      iconColor: Colors.green,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _infoColumn(
                      widget.droppingInfo,
                      widget.droppingPoint,
                      alignment: CrossAxisAlignment.end,
                      icon: Icons.location_on,
                      iconColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.event_seat,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.seatDetails.length} seat${widget.seatDetails.length > 1 ? 's' : ''}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: TextButton(
                    onPressed: () => _showDetails(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(
    String topText,
    String bottomText, {
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: iconColor ?? Colors.grey,
          ),
          const SizedBox(height: 4),
        ],
        Text(
          topText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
        const SizedBox(height: 4),
        Text(
          bottomText,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
      ],
    );
  }
}