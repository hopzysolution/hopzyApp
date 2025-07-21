// lib/services/seat_service.dart
import '../models/seat_model.dart';

class SeatService {
  // Simulate API call with delay
  Future<List<Seat>> getSeats() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _generateDummySeats();
  }

  List<Seat> _generateDummySeats() {
    final seats = <Seat>[];

    // Generate 10 rows with 4 seats each (2+2 layout)
    for (int row = 0; row < 10; row++) {
      for (int col = 0; col < 4; col++) {
        final seatNumber = row * 4 + col + 1;
        final seatId = seatNumber.toString().padLeft(2, '0');

        // Determine seat status
        SeatStatus status;
        if (seatNumber % 5 == 0) {
          status = SeatStatus.booked;
        } else if (seatNumber % 7 == 0) {
          status = SeatStatus.ladies;
        } else if (seatNumber % 13 == 0) {
          status = SeatStatus.unavailable;
        } else {
          status = SeatStatus.available;
        }

        // Determine seat type and price
        SeatType type = SeatType.regular;
        double price = 500.0;

        if (row < 2) {
          type = SeatType.premium;
          price = 700.0;
        } else if (row >= 8) {
          type = SeatType.sleeper;
          price = 600.0;
        }

        // Add some price variation
        price += (seatNumber % 3) * 50;

        seats.add(Seat(
          id: seatId,
          status: status,
          price: price,
          row: row,
          column: col,
          type: type,
        ));
      }
    }

    return seats;
  }
}
