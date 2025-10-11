import 'package:ridebooking/models/bus_data.dart';
import 'package:ridebooking/models/profile_data_model.dart';
import 'package:ridebooking/models/seat_layout_data_model.dart';
import 'package:ridebooking/models/seat_modell.dart';

abstract class SeatLayoutState {}
class SeatLayoutInitial extends SeatLayoutState {}
class SeatLayoutLoading extends SeatLayoutState {}
class SeatLayoutLoaded extends SeatLayoutState {
  final SeatLayoutDataModel? seatLayout;
  BusData? busData;
  List<SeatModell>? seatModelList;
  ProfileDataModel? profileDataModel;

  SeatLayoutLoaded({this.seatLayout,this.busData,this.seatModelList,profileDataModel});
}
class SeatLayoutFailure extends SeatLayoutState {
  final String error;

  SeatLayoutFailure({required this.error});
}

class ProfileDetailsState extends SeatLayoutState {
ProfileDataModel? profileDataModel;

  ProfileDetailsState({this.profileDataModel});
}