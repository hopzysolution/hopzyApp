import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/bloc/splash_screen_bloc/splash_screen_event.dart';
import 'package:ridebooking/bloc/splash_screen_bloc/splash_screen_state.dart';
import 'package:ridebooking/models/operator_list_model.dart';
import 'package:ridebooking/globels.dart' as globals;

class SplashScreenBloc extends Bloc<SplashScreenEvent,SplashScreenState> {

  List<StationListModel> operatorList=[]; 
  StationListModel? stationListModel;

  SplashScreenBloc():super(SplashScreenInitial()){
    // onLoadOperatorList();
  }


//   onLoadOperatorList() async{


//     var headers = {
//   'token': 'MTE1YzI2YzEwOWMxMDdjOTNjMTA2YzEwMmM4OWMxMDFjOTNjMjZjNTBjMjRjMjZjOTZjMTAzYzEwNGMxMTRjMTEzYzEwN2MxMDBjMjZjMzZjMjZjMTA0Yzg5YzEwN2MxMDdjMTExYzEwM2MxMDZjOTJjMjZjNTBjMjZjNjRjMTAzYzc1YzEwM2M0MmMxMDRjMTA4YzQ5YzI2YzExN2M3MA==',
//   'Content-Type': 'application/json',
//   'User-Agent': 'insomnia/11.2.0',
//   'Authorization': 'Bearer Bearer MTE1YzI2YzEwOWMxMDdjOTNjMTA2YzEwMmM4OWMxMDFjOTNjMjZjNTBjMjRjMjZjOTZjMTAzYzEwNGMxMTRjMTEzYzEwN2MxMDBjMjZjMzZjMjZjMTA0Yzg5YzEwN2MxMDdjMTExYzEwM2MxMDZjOTJjMjZjNTBjMjZjNjRjMTAzYzc1YzEwM2M0MmMxMDRjMTA4YzQ5YzI2YzExN2M3MA==',
//   'Cookie': 'PHPSESSID=iej3lucbta9s50bmqoksviueon'
// };
// var dio = Dio();
// var response = await dio.request(
//   // 'https://api.vaagaibus.in/api/GetOperatorList/hopzy',
//   "https://stagingapi.hopzy.in/api/public/stations?search=chenn&type=dst&page=1&limit=10",
//   options: Options(
//     method: 'GET',
//     headers: headers,
//   ),
// );

// if (response.statusCode == 200) {

//  stationListModel = StationListModel.fromJson(response.data);
//  globals.stationListModel = stationListModel!;
// //  emit(Spla)

//   debugPrint("Data to see -------------->>>>${stationListModel!.data!.dstCount}");
// }
// else {
//   print(response.statusMessage);
// }

//   }



}