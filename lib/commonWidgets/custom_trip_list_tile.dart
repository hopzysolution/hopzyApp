import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/models/trip_model.dart';
import 'package:ridebooking/utils/app_colors.dart';

class TripListTile extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onTap;

  const TripListTile({super.key, required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width=MediaQuery.of(context).size.width;

    // Calculate seat availability percentage
    final availabilityPercentage =
        int.parse(trip.availableSeats) / int.parse(trip.totalSeats);
    final isLowAvailability = availabilityPercentage < 0.3;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap:
            onTap ??
            () {
              // Handle booking or detail navigation
            },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with operator name and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.65,
                        child: Text(
                          trip.operatorName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _calculateDuration(
                              trip.departureTime,
                              trip.arrivalTime,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " • ",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.neutral400,

                              // fontSize: AppSizes.md,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${trip.availableSeats} Seats", //${trip.totalSeats} available',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isLowAvailability
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (trip.price != null) //price
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        // "₹ 600",
                        '₹ ${trip.price}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Route information
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.jm().format(
                                      trip.departureTime,
                                    ), // trip.srcName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Journey line
                        Row(
                          children: [
                            const SizedBox(width: 4),
                            Container(
                              width: 1,
                              height: 20,
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary.withOpacity(0.3),
                                      colorScheme.primary.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.jm().format(trip.arrivalTime),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5
              ),

              Wrap(
                spacing: 6, // horizontal gap
                runSpacing: 6, // vertical gap (between lines)
                children: [
                  // Bus type chip
                  _buildChip(
                    icon: Icons.directions_bus,
                    label: trip.busType,
                    colorScheme: colorScheme,
                    theme: theme,
                  ),

                  // Boarding / Droping point
                  _buildChip(

                    icon: Icons.location_on,
                    label: "Boarding / Droping Points",
                    colorScheme: colorScheme,
                    theme: theme,
                  ),

                  // Amenities (Example)
                  _buildChip(

                    icon: Icons.chair, // or custom icon
                    label: "Amenities",
                    colorScheme: colorScheme,
                    theme: theme,
                  ),

                  //Cancellation Policy
                  _buildChip(

                    icon: Icons.cancel_sharp, // or custom icon
                    label: "Cancellation Policies",
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateDuration(DateTime departure, DateTime arrival) {
    final duration = arrival.difference(departure);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,

              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,


            ),
          ),
        ],
      ),
    );
  }
}
