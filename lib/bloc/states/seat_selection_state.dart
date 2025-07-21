// lib/bloc/states/seat_selection_state.dart
import 'package:equatable/equatable.dart';
import '../../models/seat_model.dart';

abstract class SeatSelectionState extends Equatable {
  const SeatSelectionState();

  @override
  List<Object?> get props => [];
}

class SeatSelectionInitial extends SeatSelectionState {}

class SeatSelectionLoading extends SeatSelectionState {}

class SeatSelectionLoaded extends SeatSelectionState {
  final List<Seat> seats;
  final List<String> selectedSeatIds;
  final double totalPrice;

  const SeatSelectionLoaded({
    required this.seats,
    required this.selectedSeatIds,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [seats, selectedSeatIds, totalPrice];

  SeatSelectionLoaded copyWith({
    List<Seat>? seats,
    List<String>? selectedSeatIds,
    double? totalPrice,
  }) {
    return SeatSelectionLoaded(
      seats: seats ?? this.seats,
      selectedSeatIds: selectedSeatIds ?? this.selectedSeatIds,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  List<Seat> get selectedSeats =>
      seats.where((seat) => selectedSeatIds.contains(seat.id)).toList();

  int get selectedSeatCount => selectedSeatIds.length;
}

class SeatSelectionError extends SeatSelectionState {
  final String message;

  const SeatSelectionError(this.message);

  @override
  List<Object?> get props => [message];
}
