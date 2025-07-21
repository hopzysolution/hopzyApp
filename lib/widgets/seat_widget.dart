
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/seate_selection_bloc.dart';
import '../models/seat_model.dart';
import '../bloc/events/seat_selection_event.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;

  const SeatWidget({
    Key? key,
    required this.seat,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onSeatTap(context),
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getSeatColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _getSeatColor().withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                seat.id,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (seat.type == SeatType.premium)
              const Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12,
                ),
              ),
            if (seat.type == SeatType.sleeper)
              const Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.bed,
                  color: Colors.white70,
                  size: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onSeatTap(BuildContext context) {
    if (seat.status == SeatStatus.booked ||
        seat.status == SeatStatus.unavailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            seat.status == SeatStatus.booked
                ? 'Seat ${seat.id} is already booked'
                : 'Seat ${seat.id} is unavailable',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final bloc = context.read<SeatSelectionBloc>();
    if (isSelected) {
      bloc.add(DeselectSeat(seat.id));
    } else {
      bloc.add(SelectSeat(seat.id));
    }
  }

  Color _getSeatColor() {
    switch (seat.status) {
      case SeatStatus.available:
        return const Color(0xFF4CAF50); // Green
      case SeatStatus.booked:
        return const Color(0xFF9E9E9E); // Gray
      case SeatStatus.selected:
        return const Color(0xFF2196F3); // Blue
      case SeatStatus.ladies:
        return const Color(0xFFE91E63); // Pink
      case SeatStatus.unavailable:
        return const Color(0xFF616161); // Dark Gray
    }
  }

  Color _getTextColor() {
    switch (seat.status) {
      case SeatStatus.available:
      case SeatStatus.booked:
      case SeatStatus.selected:
      case SeatStatus.ladies:
      case SeatStatus.unavailable:
        return Colors.white;
    }
  }
}
