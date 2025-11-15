import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(color: AppColors.neutral50),
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.neutral50,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => BookingListBloc(),
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
                                  state.cancelDetails.seatNo.join(','),
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
                return const Center(
                  child: Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingListBloc>().add(FetchBookingsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];
                    return BookingCard(booking: booking);
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(booking.bookedAt);
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);

    // Get boarding point name safely
    final boardingPointName = booking.boardingPointName;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Ticket ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${booking.ticketId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (booking.pnr.isNotEmpty)
                        Text(
                          'PNR: ${booking.pnr}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: booking.status == 'confirmed'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: booking.status == 'confirmed'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Route Information
            if (booking.from != null && booking.to != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.from!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          boardingPointName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          booking.to!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (booking.droppingPoint?['name'] != null)
                          Text(
                            booking.droppingPoint!['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            
            // Booking Details
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '$formattedDate at $formattedTime',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (booking.bustype != null) ...[
              Row(
                children: [
                  const Icon(Icons.directions_bus, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.bustype!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            Row(
              children: [
                const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Seats: ${booking.passengers.map((p) => p.seatNo).join(', ')}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.monetization_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Total Fare: ₹${booking.totalFare}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            // Cancelled Date if applicable
            if (booking.status == 'cancelled' && booking.cancelledAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.cancel, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Cancelled on: ${DateFormat('MMM d, yyyy').format(DateTime.parse(booking.cancelledAt!))}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Cancel Button
            if (booking.status == 'confirmed')
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Get the first passenger's seat number
                    final seatNo = booking.passengers.isNotEmpty
                        ? booking.passengers.first.seatNo
                        : '';
                    
                    context.read<BookingListBloc>().add(
                          FetchCancelDetailsEvent(
                            booking.pnr,
                            seatNo,
                            booking.ticketId,
                            booking, // Pass the complete booking object
                          ),
                        );
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Cancel Booking'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
