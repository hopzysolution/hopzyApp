import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/utils/toast_messages.dart';

import '../../models/passenger_model.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BookingListBloc()..add(FetchBookingsEvent()),
        child: BlocConsumer<BookingListBloc, BookingListState>(
          listener: (context, state) {
            if (state is BookingCancelledSuccess) {
              ToastMessage().showSuccessToast(state.message);
            } else if (state is BookingListFailure) {
              ToastMessage().showErrorToast(state.error);
            } else if (state is CancelDetailsLoaded) {
              final parentContext = context;
              showDialog(
                context: parentContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Cancel Booking'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PNR: ${state.pnr}'),
                      const SizedBox(height: 8),
                      Text('Ticket Fare: ₹${state.cancelDetails.ticketFare}'),
                      Text(
                        'Cancellation Charge: ₹${state.cancelDetails.cancellationCharge.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Refund Amount: ₹${state.cancelDetails.refundAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Do you want to proceed with cancellation?',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        parentContext.read<BookingListBloc>().add(
                          CancelBookingEvent(
                            state.pnr!,
                            state.cancelDetails.seatNo,
                          ),
                        );
                        Navigator.pop(dialogContext);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text('Yes, Cancel'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BookingListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingListLoaded) {
              if (state.bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No bookings found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your tickets will appear here',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingListBloc>().add(FetchBookingsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];
                    return _buildTicketCard(context, booking);
                  },
                ),
              );
            } else if (state is BookingListFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<BookingListBloc>().add(
                        FetchBookingsEvent(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("Tickets"));
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Booking booking) {
    final date = DateTime.parse(booking.bookedAt);
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);
    final boardingPointName = booking.boardingPointName;
    final droppingPointName = booking.droppingPoint?['name'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Top Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: booking.status == 'confirmed'
                      ? [Colors.blue[700]!, Colors.blue[500]!]
                      : [Colors.red[700]!, Colors.red[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Bus Number and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.directions_bus,
                                color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking.bustype ?? 'Bus',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: booking.status == 'confirmed'
                              ? Colors.green
                              : Colors.red[900],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // From and To Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FROM',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.from ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              boardingPointName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 24),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'TO',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.to ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              droppingPointName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Dotted Line with Circles
            Stack(
              children: [
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: List.generate(
                          (constraints.maxWidth / 8).floor(),
                              (index) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: -8,
                  top: -8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Section
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  // Date and Seat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                          Icons.calendar_today, 'Date', formattedDate),
                      _buildInfoItem(
                        Icons.event_seat,
                        'Seat',
                        booking.passengers
                            .map((p) => p.seatNo)
                            .join(', '),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Passenger and Booking ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        Icons.person,
                        'Passenger',
                        booking.passengers.isNotEmpty
                            ? booking.passengers.first.name
                            : 'N/A',
                      ),
                      _buildInfoItem(
                        Icons.confirmation_number,
                        'Booking ID',
                        booking.ticketId,
                      ),
                    ],
                  ),

                  // Additional Info Row - PNR and Total Fare
                  if (booking.pnr.isNotEmpty || booking.totalFare > 0) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (booking.pnr.isNotEmpty)
                          _buildInfoItem(
                            Icons.receipt_long,
                            'PNR',
                            booking.pnr,
                          ),
                        _buildInfoItem(
                          Icons.monetization_on,
                          'Total Fare',
                          '₹${booking.totalFare}',
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // View Details Button or Cancel Status
                  if (booking.status == 'confirmed')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final pnr = booking.pnr;
                          final ticketId = booking.ticketId;
                          final provider = booking.opid; // ✅ Correct provider field

                          final seatNo = (booking.passengers != null && booking.passengers!.isNotEmpty)
                              ? booking.passengers!.first.seatNo
                              : '';

                          print("✅ PNR: $pnr");
                          print("✅ Ticket ID: $ticketId");
                          print("✅ Provider (opid): $provider");
                          print("✅ Seat No: $seatNo");

                          context.read<BookingListBloc>().add(
                            FetchCancelDetailsEvent(
                              pnr,
                              seatNo,
                              ticketId,
                              booking, // ✅ passing complete booking object
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6,),
                            const Text(
                              'Cancel Booking',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel, size: 20, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            booking.cancelledAt != null
                                ? 'Cancelled on ${DateFormat('MMM d, yyyy').format(DateTime.parse(booking.cancelledAt!))}'
                                : 'Booking Cancelled',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    final date = DateTime.parse(booking.bookedAt);
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Journey Details
              _buildDetailSection(
                'Journey Information',
                [
                  _buildDetailRow('From', booking.from ?? 'N/A'),
                  _buildDetailRow(
                      'Boarding Point', booking.boardingPointName),
                  _buildDetailRow('To', booking.to ?? 'N/A'),
                  _buildDetailRow('Dropping Point',
                      booking.droppingPoint?['name'] ?? 'N/A'),
                  _buildDetailRow('Bus Type', booking.bustype ?? 'N/A'),
                ],
              ),

              const SizedBox(height: 20),

              // Booking Details
              _buildDetailSection(
                'Booking Information',
                [
                  _buildDetailRow('Ticket ID', booking.ticketId),
                  if (booking.pnr.isNotEmpty)
                    _buildDetailRow('PNR', booking.pnr),
                  _buildDetailRow('Booking Date', formattedDate),
                  _buildDetailRow('Booking Time', formattedTime),
                  _buildDetailRow('Status', booking.status.toUpperCase()),
                ],
              ),

              const SizedBox(height: 20),

              // Passenger Details
              _buildDetailSection(
                'Passenger Details',
                booking.passengers
                    .map((p) => _buildPassengerCard(p as Passenger))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // Fare Details
              _buildDetailSection(
                'Fare Details',
                [
                  _buildDetailRow('Total Fare', '₹${booking.totalFare}'),
                ],
              ),

              const SizedBox(height: 20),

              // Cancel Button
              if (booking.status == 'confirmed')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      final seatNo = booking.passengers.isNotEmpty
                          ? booking.passengers.first.seatNo
                          : '';

                      context.read<BookingListBloc>().add(
                        FetchCancelDetailsEvent(
                          booking.pnr,
                          seatNo,
                          booking.ticketId,
                          booking,
                        ),
                      );
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 20),
                    label: const Text('Cancel Booking'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(Passenger passenger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  passenger.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Seat ${passenger.seatNo}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.cake, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${passenger.age} years',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(
                passenger.gender.toLowerCase() == 'male'
                    ? Icons.male
                    : Icons.female,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                passenger.gender,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
