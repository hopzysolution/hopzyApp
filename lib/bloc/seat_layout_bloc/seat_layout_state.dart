import 'package:ridebooking/models/seat_layout_data_model.dart';

abstract class SeatLayoutState {}
class SeatLayoutInitial extends SeatLayoutState {}
class SeatLayoutLoading extends SeatLayoutState {}
class SeatLayoutLoaded extends SeatLayoutState {
  final SeatLayoutDataModel? seatLayout;

  SeatLayoutLoaded({this.seatLayout});
}
class SeatLayoutFailure extends SeatLayoutState {
  final String error;

  SeatLayoutFailure({required this.error});
}