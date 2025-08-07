import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';
import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample booking data
    final bookings = [
      Booking(
        id: 'B001',
        title: 'Chennai to Erode',
        date: 'Aug 8, 2025',
        time: '2:00 PM',
        location: 'Chennai to Erode',
      ),
      Booking(
        id: 'B002',
        title: 'Chennai to Erode',
        date: 'Aug 9, 2025',
        time: '7:00 PM',
        location: 'Chennai to Erode',
      ),
      Booking(
        id: 'B003',
        title: 'Chennai to Erode',
        date: 'Aug 10, 2025',
        time: '10:00 AM',
        location: 'Chennai to Erode',
      ),
    ];

    return 
    BlocProvider(create: (context)=>BookingListBloc(),
    child:  BlocListener<BookingListBloc,BookingListState>(
      listener: (context,state){
        if(state is BookingListFailure){
          ToastMessage().showErrorToast(state.error);
        }
      },
      child: BlocBuilder<BookingListBloc,BookingListState>(
        builder: (context,state){
          if(state is BookingListLoading){
            return CircularProgressIndicator();
          }
          return   Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Text(
                'No bookings found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(booking: booking);
              },
            ),
    );
    
      }),
      
      )
    
   
    );
    
  
 
  }
}

class Booking {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;

  Booking({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#${booking.id}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${booking.date} at ${booking.time}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_pin, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(booking.location, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // Handle cancel action
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cancel Booking'),
                      content: Text(
                        'Are you sure you want to cancel "${booking.title}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement cancel logic here
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${booking.title} cancelled'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ridebooking/bloc/booking_list_bloc/booking_list_bloc.dart';
// import 'package:ridebooking/bloc/booking_list_bloc/booking_list_event.dart';
// import 'package:ridebooking/bloc/booking_list_bloc/booking_list_state.dart';

// class BookingListScreen extends StatelessWidget {
//   const BookingListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Bookings'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocProvider(
//         create: (context) => BookingListBloc(),
//         child:  BlocConsumer<BookingListBloc, BookingListState>(
//         listener: (context, state) {
//           if (state is BookingCancelledSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else if (state is BookingListFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error), backgroundColor: Colors.red),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is BookingListLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is BookingListLoaded) {
//             if (state.bookings.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No bookings found',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = state.bookings[index];
//                 return BookingCard(booking: booking);
//               },
//             );
//           } else if (state is BookingListFailure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     state.error,
//                     style: const TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => context.read<BookingListBloc>().add(
//                       FetchBookingsEvent(),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     ));
//   }
// }

// class BookingCard extends StatelessWidget {
//   final Booking booking;

//   const BookingCard({super.key, required this.booking});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   booking.title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '#${booking.id}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${booking.date} at ${booking.time}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_pin, size: 16, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Text(booking.location, style: const TextStyle(fontSize: 16)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Align(
//               alignment: Alignment.centerRight,
//               child: OutlinedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Cancel Booking'),
//                       content: Text(
//                         'Are you sure you want to cancel "${booking.title}"?',
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('No'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             context.read<BookingListBloc>().add(
//                               CancelBookingEvent(booking.id),
//                             );
//                           },
//                           child: const Text('Yes'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Theme.of(context).colorScheme.error),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Cancel Booking',
//                   style: TextStyle(color: Theme.of(context).colorScheme.error),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
