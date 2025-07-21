// lib/bloc/events/seat_selection_event.dart
import 'package:equatable/equatable.dart';

abstract class SeatSelectionEvent extends Equatable {
  const SeatSelectionEvent();

  @override
  List<Object?> get props => [];
}

class SelectSeat extends SeatSelectionEvent {
  final String seatId;

  const SelectSeat(this.seatId);

  @override
  List<Object?> get props => [seatId];
}

class DeselectSeat extends SeatSelectionEvent {
  final String seatId;

  const DeselectSeat(this.seatId);

  @override
  List<Object?> get props => [seatId];
}

class ClearSelection extends SeatSelectionEvent {
  const ClearSelection();
}

class LoadSeats extends SeatSelectionEvent {
  const LoadSeats();
}
