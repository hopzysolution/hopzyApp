import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_event.dart';
import 'package:ridebooking/bloc/seat_layout_bloc/seat_layout_state.dart';
import 'package:ridebooking/models/available_trip_data.dart' hide Data;
import 'package:ridebooking/models/bus_data.dart';
import 'package:ridebooking/models/profile_data_model.dart' hide Data;
import 'package:ridebooking/models/seat_layout_data_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/utils/app_const.dart';
import 'package:ridebooking/utils/session.dart';

class SeatLayoutBloc extends Bloc<SeatLayoutEvent, SeatLayoutState> {
  Trips? trip;
  Data? seatLayout;
  String? phone;
  ProfileDataModel? profileDataModel;
  List<SeatModell>? seatModelList;
  BusData? updatedBusData;

  SeatLayoutBloc(this.trip) : super(SeatLayoutInitial()) {
    // Initialize data loading
    _initializeData();
  }

  // Combined initialization method
  Future<void> _initializeData() async {
    emit(SeatLayoutLoading());
    
    try {
      // First, get profile data
   
      
      // Then, get seat layout
      await getSeatLayout();
    } catch (e) {
      print("Error in initialization: $e");
      emit(SeatLayoutFailure(error: "Failed to initialize. Please try again."));
    }
  }

 
  Future<void> getSeatLayout() async {
    try {
      var formData = trip!.provider == "vaagai"
          ? {
              "routeid": trip!.routeid,
              "tripid": trip!.tripid,
              "src": trip!.srcId,
              "dst": trip!.dstId,
              "opid": trip!.operatorid,
              "provider": trip!.provider
            }
          : {
              "tripid": trip!.tripid,
              "src": trip!.srcId,
              "dst": trip!.dstId,
              "tripdate": trip!.tripDate,
              "provider": trip!.provider,
            };

      var response = await ApiRepository.postAPI(
        ApiConst.getSeatLayout, 
        formData, 
        basurl2: ApiConst.baseUrl2
      );
      
      final data = response.data;

      if (data["status"] != null && data["status"] == 1) {
        SeatLayoutDataModel seatLayoutDataModel = SeatLayoutDataModel.fromJson(data);
        getseatList(seatLayoutDataModel);
        updateBusData(seatLayoutDataModel);
        seatLayout = seatLayoutDataModel.data!;

        String jsonString = response.toString();
        Map<String, dynamic> jsonData = jsonDecode(jsonString);
        List<dynamic> seatInfoList = jsonData['data']['seatInfo'];

        List<String> seatNumbers = seatInfoList
            .map((seat) => seat['seatNo'] as String)
            .where((seatNo) => seatNo.isNotEmpty && seatNo != "-")
            .toList();

        await Session.saveAllSeats(seatNumbers);
        print("Data----------->>>>>>>>>> ${seatNumbers}");

        // Emit the loaded state with all required data INCLUDING profileDataModel
        emit(SeatLayoutLoaded(
          seatLayout: seatLayoutDataModel,
          busData: updatedBusData,
          seatModelList: seatModelList, // This should now have data
        ));
      } else {
        final message = data["status"]?["message"] ?? "Failed to load trips";
        emit(SeatLayoutFailure(error: message));
      }
    } catch (e) {
      print("Error in getSeatLayout: $e");
      emit(SeatLayoutFailure(error: "Something went wrong. Please try again."));
    }
  }

  void getseatList(SeatLayoutDataModel seatLayoutDataModel) {
    var response = seatLayoutDataModel;
    final seatInfoList = response.data?.seatInfo ?? [];

    seatModelList = seatInfoList
        .where((seat) => seat.seatNo != '-')
        .map((seat) {
      return SeatModell(
        seatNo: seat.seatNo ?? '',
        fare: seat.fare ?? 0,
        available: seat.seatstatus!,
      );
    }).toList();

    for (var seat in seatModelList!) {
      print(
          "<><><><><><><><<><<><><><><><>${seat.available} ${seat.seatNo} ${seat.fare}");
    }
  }

  void updateBusData(SeatLayoutDataModel seatLayoutDataModel) {
    final BusData originalBusData = AppConst.busdata;
    
    List<Seats> updatedSeats = seatModelList!.asMap().entries.map((entry) {
      int index = entry.key;
      SeatModell seat = entry.value;

      Seats? original = (originalBusData.seats != null && 
                         index < originalBusData.seats!.length)
          ? originalBusData.seats![index]
          : null;

      return Seats(
        seatNumber: seat.seatNo,
        fare: seat.fare,
        status: seat.available == "A"
            ? "Available"
            : seat.available == "F"
                ? "femaleBooked"
                : seat.available == "M"
                    ? "maleBooked"
                    : "booked",
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

    for (var seat in updatedBusData!.seats ?? []) {
      print('=======>>SeatNo: ${seat.seatNumber}, Fare: ${seat.fare}, Status: ${seat.status}');
    }
  }
}