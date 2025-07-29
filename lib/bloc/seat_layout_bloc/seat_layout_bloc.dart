import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_event.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/seat_layout_data_model.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';

class SeatLayoutBloc extends Bloc<SeatLayoutEvent, SeatLayoutState> {
  final Availabletrips? trip;

  Layout? seatLayout;

  SeatLayoutBloc(this.trip) : super(SeatLayoutInitial()) {
    // on<SeatLayoutFetchEvent>((event, emit) async {
    //   emit(SeatLayoutLoading());
    //   try {
    //     var formData = {
    //       "src_order": event.srcOrder,
    //       "dst_order": event.dstOrder,
    //       "route_id": event.routeId,
    //       "trip_id": event.tripId,
    //       "opid": event.opid,//"VGT"
    //     };

    //     var response = await ApiRepository.postAPI(ApiConst.getSeatLayout, formData);
    //     final data = response.data; // ✅ Extract actual response map

    //     if (data["status"] != null && data["status"]["success"] == true) {
    //       SeatLayoutDataModel seatLayoutDataModel = SeatLayoutDataModel.fromJson(data);
    //       seatLayout = seatLayoutDataModel.layout!;
    //       emit(SeatLayoutLoaded(seatLayout: seatLayoutDataModel));
    //     } else {
    //       final message = data["status"]?["message"] ?? "Failed to load trips";
    //       emit(SeatLayoutFailure(error: message));
    //     }
    //   } catch (e) {
    //     print("Error in getAvailableTrips: $e");
    //     emit(SeatLayoutFailure(error: "Something went wrong. Please try again."));
    //   }
    // });
    getSeatLayout();
  }


  void getSeatLayout()async {
      emit(SeatLayoutLoading());
      try {
        var formData = {
          "routeid": trip!.routeid,
          "tripid": trip!.tripid,
          "srcorder": trip!.srcorder,
          "dstorder": trip!.dstorder,
          "opid": trip!.operatorid,//"VGT"
        };

        var response = await ApiRepository.postAPI(ApiConst.getSeatLayout, formData);
        final data = response.data; // ✅ Extract actual response map

        if (data["status"] != null && data["status"]["success"] == true) {
          SeatLayoutDataModel seatLayoutDataModel = SeatLayoutDataModel.fromJson(data);
          seatLayout = seatLayoutDataModel.layout!;
          emit(SeatLayoutLoaded(seatLayout: seatLayoutDataModel));
        } else {
          final message = data["status"]?["message"] ?? "Failed to load trips";
          emit(SeatLayoutFailure(error: message));
        }
      } catch (e) {
        print("Error in getAvailableTrips: $e");
        emit(SeatLayoutFailure(error: "Something went wrong. Please try again."));
      }
    }


}