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
        
        title: const Text('My Bookings',style: TextStyle(
          color: AppColors.neutral50
        ),),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,
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
              final parentContext=context;
              showDialog(

                context: parentContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Cancel Booking'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PNR: ${state.cancelDetails.seatNo}'),
                      Text('Ticket Fare: ₹${state.cancelDetails.ticketFare}'),
                      Text(
                        'Cancellation Charge: ₹${state.cancelDetails.cancellationCharge}',
                      ),
                      Text(
                        'Refund Amount: ₹${state.cancelDetails.refundAmount}',
                      ),
                      const SizedBox(height: 8),
                      const Text('Do you want to proceed with cancellation?'),
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
                      child: const Text('Yes'),
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
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return BookingCard(booking: booking);
                },
              );
            } else if (state is BookingListFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.error,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
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

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '#${booking.ticketId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: booking.status == 'confirmed'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '$formattedDate at $formattedTime',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_pin, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Boarding: ${booking.boardingPoint}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Seats: ${booking.passengers.map((p) => p.seatNo).join(', ')}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Total Fare: ₹${booking.totalFare}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: booking.status == 'confirmed'
                    ? () {
                        // Assuming only one passenger per booking for simplicity
                        final seatNo = booking.passengers.isNotEmpty
                            ? booking.passengers.first.seatNo
                            : '';
                        context.read<BookingListBloc>().add(
                          FetchCancelDetailsEvent(booking.pnr, seatNo,booking.ticketId),
                        );
                      }
                    : null, // Disable button if not confirmed
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(
                    color: booking.status == 'confirmed'
                        ? Theme.of(context).colorScheme.error
                        : Colors.grey,
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
