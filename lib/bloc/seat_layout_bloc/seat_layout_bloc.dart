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
        available: seat.seatstatus == 'A',
      );
    }).toList();

// Print result for verification
    for (var seat in seatModelList!) {
      print(
          "<><><><><><><><<><<><><><><><>${seat.available} ${seat.seatNo} ${seat.fare}");
    }
  }

  BusData updatedBusData = BusData();
  updateBusData(SeatLayoutDataModel seatLayoutDataModel) {
    // Step 1: Existing static BusData
    final BusData originalBusData = AppConst.busdata;

      // seatLayoutDataModel = seatLayoutDataModel;

// Step 2: New seat data from SeatLayoutDataModel
    List<SeatInfo> seatInfoList = seatLayoutDataModel.layout?.seatInfo ?? [];

// Step 3: Update only seatNumber, fare, and status
    List<Seats> updatedSeats = originalBusData.seats?.map((busSeat) {
          final matchingSeat = seatInfoList.firstWhere(
            (info) => info.seatNo == busSeat.seatNumber,
            orElse: () => SeatInfo(),
          );

          return Seats(
            seatNumber: matchingSeat.seatNo ?? busSeat.seatNumber,
            fare: matchingSeat.fare ?? busSeat.fare,
            status: matchingSeat.seatstatus ?? busSeat.status,

            // Preserve original values for all others
            row: busSeat.row,
            column: busSeat.column,
            berth: busSeat.berth,
            gender: busSeat.gender,
            seatType: busSeat.seatType,
            isAC: busSeat.isAC,
            tax: busSeat.tax,
          );
        }).toList() ??
        [];

// Step 4: Create new BusData with updated seats
    updatedBusData = BusData(
      totalRows: originalBusData.totalRows,
      totalColumns: originalBusData.totalColumns,
      seats: updatedSeats,
    );

// ✅ Print to verify
    for (var seat in updatedBusData.seats ?? []) {
      print(
          'SeatNo:-------->>>>> ${seat.seatNumber}, Fare: ${seat.fare}, Status: ${seat.status}');
    }
  }


}