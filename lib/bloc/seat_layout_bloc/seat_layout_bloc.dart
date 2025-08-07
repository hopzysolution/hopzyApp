import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_event.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/bus_data.dart';
import 'package:ridebooking/models/seat_layout_data_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/app_const.dart';
import 'package:ridebooking/utils/session.dart';

class SeatLayoutBloc extends Bloc<SeatLayoutEvent, SeatLayoutState> {
   Availabletrips? trip;

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
          getseatList(seatLayoutDataModel);
          updateBusData(seatLayoutDataModel);
          seatLayout = seatLayoutDataModel.layout!;

 String jsonString = response.toString();

  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  List<dynamic> seatInfoList = jsonData['layout']['seatInfo'];

  // Create a list of seatNo strings, filtering out empty or null seat numbers
  List<String> seatNumbers = seatInfoList
      .map((seat) => seat['seatNo'] as String)
      .where((seatNo) => seatNo.isNotEmpty && seatNo != "-")
      .toList();

      await Session.saveAllSeats(seatNumbers);

  // print(seatNumbers);

  print("Data----------->>>>>>>>>> ${seatNumbers}");

          emit(SeatLayoutLoaded(seatLayout: seatLayoutDataModel,busData: updatedBusData,seatModelList: seatModelList));
        } else {
          final message = data["status"]?["message"] ?? "Failed to load trips";
          emit(SeatLayoutFailure(error: message));
        }
      } catch (e) {
        print("Error in getAvailableTrips: $e");
        emit(SeatLayoutFailure(error: "Something went wrong. Please try again."));
      }
    }

List<SeatModell>? seatModelList;

  getseatList(SeatLayoutDataModel seatLayoutDataModel) {
    var response = seatLayoutDataModel;

    // final jsonString =
    //     response.toString(); // ← Replace this with your actual JSON string

    // final jsonData = jsonDecode(jsonString);
    final seatInfoList = response.layout?.seatInfo ?? [];

    // Filter out any seat with seatNo == "-"
    seatModelList = seatInfoList
        .where((seat) => seat.seatNo != '-') // Exclude unwanted seats
        .map((seat) {
      return SeatModell(
        seatNo: seat.seatNo ?? '',
        fare: seat.fare ?? 0,
        available: seat.seatstatus!,
      );
    }).toList();

// Print result for verification
    for (var seat in seatModelList!) {
      print(
          "<><><><><><><><<><<><><><><><>${seat.available} ${seat.seatNo} ${seat.fare}");
    }
  }

  BusData? updatedBusData;

updateBusData(SeatLayoutDataModel seatLayoutDataModel) {
  final BusData originalBusData = AppConst.busdata;
List<Seats> updatedSeats = seatModelList!.asMap().entries.map((entry) {
  int index = entry.key;
  SeatModell seat = entry.value;

  Seats? original = (originalBusData.seats != null && index < originalBusData.seats!.length)
      ? originalBusData.seats![index]
      : null;

  return Seats(
    seatNumber: seat.seatNo,
    fare: seat.fare,
    status: seat.available=="A"?"Available":seat.available=="F"?"femaleBooked":seat.available=="M"?"maleBooked":"booked",
    row: original?.row ?? 0,
    column: original?.column ?? 0,
    berth: original?.berth ?? '',
    gender: original?.gender ?? '',
    seatType: original?.seatType ?? '',
    isAC: original?.isAC ?? false,
    tax: original?.tax ?? 0,
  );
}).toList();


  updatedBusData = BusData(
    totalRows: originalBusData.totalRows,
    totalColumns: originalBusData.totalColumns,
    seats: updatedSeats,
  );

  // Print for verification
  for (var seat in updatedBusData!.seats ?? []) {
    print('=======>>SeatNo: ${seat.seatNumber}, Fare: ${seat.fare}, Status: ${seat.status}');
  }
}



}