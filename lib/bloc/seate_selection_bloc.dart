
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ridebooking/services/seat_services.dart';
// import '../models/seat_model.dart';
// import 'events/seat_selection_event.dart';
// import 'states/seat_selection_state.dart';

// class SeatSelectionBloc extends Bloc<SeatSelectionEvent, SeatSelectionState> {
//   final SeatService _seatService;
//   static const int maxSeatsAllowed = 6;

//   SeatSelectionBloc(this._seatService) : super(SeatSelectionInitial()) {
//     on<LoadSeats>(_onLoadSeats);
//     on<SelectSeat>(_onSelectSeat);
//     on<DeselectSeat>(_onDeselectSeat);
//     on<ClearSelection>(_onClearSelection);
//   }

//   void _onLoadSeats(LoadSeats event, Emitter<SeatSelectionState> emit) async {
//     emit(SeatSelectionLoading());
//     try {
//       final seats = await _seatService.getSeats();
//       emit(SeatSelectionLoaded(
//         seats: seats,
//         selectedSeatIds: [],
//         totalPrice: 0.0,
//       ));
//     } catch (e) {
//       emit(SeatSelectionError('Failed to load seats: ${e.toString()}'));
//     }
//   }

//   void _onSelectSeat(SelectSeat event, Emitter<SeatSelectionState> emit) {
//     if (state is SeatSelectionLoaded) {
//       final currentState = state as SeatSelectionLoaded;
//       final seat = currentState.seats.firstWhere(
//         (seat) => seat.id == event.seatId,
//         orElse: () => throw Exception('Seat not found'),
//       );

//       // Check if seat is selectable
//       if (!seat.isSelectable) return;

//       // Check if seat is already selected
//       if (currentState.selectedSeatIds.contains(event.seatId)) return;

//       // Check maximum seats limit
//       if (currentState.selectedSeatIds.length >= maxSeatsAllowed) {
//         emit(SeatSelectionError('Maximum $maxSeatsAllowed seats allowed'));
//         return;
//       }

//       // Update seat status to selected
//       final updatedSeats = currentState.seats.map((s) {
//         if (s.id == event.seatId) {
//           return s.copyWith(status: SeatStatus.selected);
//         }
//         return s;
//       }).toList();

//       final updatedSelectedIds = [
//         ...currentState.selectedSeatIds,
//         event.seatId
//       ];
//       final totalPrice = _calculateTotalPrice(updatedSeats, updatedSelectedIds);

//       emit(currentState.copyWith(
//         seats: updatedSeats,
//         selectedSeatIds: updatedSelectedIds,
//         totalPrice: totalPrice,
//       ));
//     }
//   }

//   void _onDeselectSeat(DeselectSeat event, Emitter<SeatSelectionState> emit) {
//     if (state is SeatSelectionLoaded) {
//       final currentState = state as SeatSelectionLoaded;
//       final seat = currentState.seats.firstWhere(
//         (seat) => seat.id == event.seatId,
//         orElse: () => throw Exception('Seat not found'),
//       );

//       // Check if seat is selected
//       if (!currentState.selectedSeatIds.contains(event.seatId)) return;

//       // Update seat status based on original status
//       final originalStatus =
//           seat.type == SeatType.regular && seat.id.hashCode % 7 == 0
//               ? SeatStatus.ladies
//               : SeatStatus.available;

//       final updatedSeats = currentState.seats.map((s) {
//         if (s.id == event.seatId) {
//           return s.copyWith(status: originalStatus);
//         }
//         return s;
//       }).toList();

//       final updatedSelectedIds = currentState.selectedSeatIds
//           .where((id) => id != event.seatId)
//           .toList();
//       final totalPrice = _calculateTotalPrice(updatedSeats, updatedSelectedIds);

//       emit(currentState.copyWith(
//         seats: updatedSeats,
//         selectedSeatIds: updatedSelectedIds,
//         totalPrice: totalPrice,
//       ));
//     }
//   }

//   void _onClearSelection(
//       ClearSelection event, Emitter<SeatSelectionState> emit) {
//     if (state is SeatSelectionLoaded) {
//       final currentState = state as SeatSelectionLoaded;

//       final updatedSeats = currentState.seats.map((seat) {
//         if (seat.status == SeatStatus.selected) {
//           final originalStatus =
//               seat.type == SeatType.regular && seat.id.hashCode % 7 == 0
//                   ? SeatStatus.ladies
//                   : SeatStatus.available;
//           return seat.copyWith(status: originalStatus);
//         }
//         return seat;
//       }).toList();

//       emit(currentState.copyWith(
//         seats: updatedSeats,
//         selectedSeatIds: [],
//         totalPrice: 0.0,
//       ));
//     }
//   }

//   double _calculateTotalPrice(List<Seat> seats, List<String> selectedIds) {
//     return selectedIds.fold(0.0, (sum, id) {
//       final seat = seats.firstWhere((seat) => seat.id == id);
//       return sum + seat.price;
//     });
//   }
// }
