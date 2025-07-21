// lib/widgets/seat_layout.dart
import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import 'seat_widget.dart';

class SeatLayout extends StatelessWidget {
  final List<Seat> seats;
  final List<String> selectedSeatIds;

  const SeatLayout({
    Key? key,
    required this.seats,
    required this.selectedSeatIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Driver section
          // _buildDriverSection(),
          const SizedBox(height: 10),

          // Seat grid
          _buildSeatGrid(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDriverSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD84E55),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_bus,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid() {
    // Group seats by row
    final seatsByRow = <int, List<Seat>>{};
    for (final seat in seats) {
      if (!seatsByRow.containsKey(seat.row)) {
        seatsByRow[seat.row] = [];
      }
      seatsByRow[seat.row]!.add(seat);
    }

    return Column(
      children: seatsByRow.entries.map((entry) {
        final row = entry.key;
        final rowSeats = entry.value;
        rowSeats.sort((a, b) => a.column.compareTo(b.column));

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row number
              // Container(
              //   width: 30,
              //   alignment: Alignment.center,
              //   child: Text(
              //     '${row + 1}',
              //     style: const TextStyle(
              //       fontSize: 12,
              //       color: Color(0xFF666666),
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 8),

              // Left side seats (columns 0, 1)
              SeatWidget(
                seat: rowSeats[0],
                isSelected: selectedSeatIds.contains(rowSeats[0].id),
              ),
              const SizedBox(width: 2),
              SeatWidget(
                seat: rowSeats[1],
                isSelected: selectedSeatIds.contains(rowSeats[1].id),
              ),

              // Aisle
              const SizedBox(width: 20),

              // Right side seats (columns 2, 3)
              SeatWidget(
                seat: rowSeats[2],
                isSelected: selectedSeatIds.contains(rowSeats[2].id),
              ),
              const SizedBox(width: 2),
              SeatWidget(
                seat: rowSeats[3],
                isSelected: selectedSeatIds.contains(rowSeats[3].id),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
