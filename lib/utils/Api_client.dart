import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_event.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_state.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/utils/toast_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ridebooking/globels.dart' as globals;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Dio dio = Dio(BaseOptions(baseUrl: "https://prodapi.hopzy.in/"));

  void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');


        if (token != null && options.path != ApiConst.refreshTokenApi) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;

          try {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refreshToken');
            if (refreshToken == null) return handler.next(error);

            final newToken = await _refreshAccessToken(refreshToken);

            if (newToken != null) {
              await prefs.setString('accessToken', newToken);
    await Session().setHopzyAccessToken(newToken);
              
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              final cloneReq = await dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            }
          } catch (e) {
            return handler.next(error);
          } finally {
            _isRefreshing = false;
          }
        }

        return handler.next(error);
      },
    ));
  }

  bool _isRefreshing = false;

  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await dio.post(ApiConst.refreshTokenApi, data: {
        'refreshToken': refreshToken,
      });

      return response.data['accessToken'];
    } catch (e) {
      print("Refresh failed: $e");
      return null;
    }
  }

  // Request OTP
 Future<Response?> requestOtp(String email) async {
  try {
    print("Request Otp URL: ${dio.options.baseUrl}${ApiConst.requesOtp}");
    print("Request Otp Headers: ${dio.options.headers}");
    print("Request Otp Data: {'email': $email}");

    final response = await dio.post(ApiConst.requesOtp, data: {'email': email});
    
    print("Request Otp Success: ${response.data}");
    return response;
  } on DioException catch (e) {
    print("Request Otp Failed:");
    print("Status: ${e.response?.statusCode}");
    print("Data: ${e.response?.data}");
    print("Message: ${e.message}");
    //  ToastMessage().showErrorToast(e.response?.data["message"]);
    // Optional: Handle specific status
    if (e.response?.statusCode == 500) {
      // Maybe show dialog or return custom error
     
    }

    return null; // Let caller decide what to do
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}


  // Verify OTP
 Future<Response?> verifyOtp(String email, String otp) async {
  try {
    final response = await dio.post(ApiConst.verifyOtp, data: {
      'email': email,
      'otp': otp,
    });

    final data = response.data;

    print("Verify OTP Success: $data");

    final prefs = await SharedPreferences.getInstance();
    await Session().setHopzyAccessToken(data["data"]["accessToken"]);
    await prefs.setString('accessToken', data["data"]["accessToken"]);
    await prefs.setString('refreshToken', data["data"]["refreshToken"]);

    return response;
  } on DioException catch (e) {
    print("Verify OTP Failed: ${e.response?.statusCode} - ${e.response?.data}");
    return null;
  }
}


//    createOrder(int fare,String phoneNo,String email,  OnContinueButtonClick event,
//     Emitter<BookingState> emit,) async{

//         print('---abc----1--create order inside call');

//      emit(BookingLoading());
//     try {

// final response = await dio.post(ApiConst.createOrder, data: {
//        "amount": 1050,
//   "phone": phoneNo,
//   "email": email
//     });
//         print('---abc---2---create order inside call');

//       // final response = await ApiRepository.postAPI(ApiConst.createOrder, formData,basurl2: ApiConst.baseUrl2);

//       final data = response.data;
//         print('---abc------create order inside call');

//        print("Response from createorder api $data");

//       // if (data["status"] != null && data["status"]["success"] == true) {
//       //   await Session().setPnr(data["BookingInfo"]["PNR"]);
//       //   emit(BookingLoaded());
//       // } else {
//       //   final message = data["status"]?["message"] ?? "Failed to load stations";
//       //   emit(BookingFailure(error: message));
//       // }
//     } catch (e) {
//       print("Error in getTentativeBooking: $e");
//       emit(BookingFailure(error: "Something went wrong. Please try again."));
//     }

//   }

// Future paymentVerification(PaymentSuccessResponse paymentVerify) async{

//     try {

// final response = await dio.post(ApiConst.paymentVerification, data: {
//   "razorpay_order_id": paymentVerify.orderId,
//   "razorpay_payment_id": paymentVerify.paymentId,
//   "razorpay_signature": paymentVerify.signature,
//   "user_id": "user_id_here",
//   "amount": 500
// });

//         final data = response.data;

//        print("Response from createorder api ----------->>>> $data");

//        return data;

//     } catch (e) {
//       print("Error in getTentativeBooking: $e");
//     }

//   }


//   Future confirmBooking(Availabletrips tripData,String bpoint,Set<SeatModell> selectedSeats,List<Passenger> selectedPassenger,String pnr,String orderId) async{

//     try {

// final response = await dio.post(ApiConst.paymentVerification, data: {
//         "razorpay_order_id": orderId,
//         "pnr": pnr,
//         "routeid": tripData.routeid,
//         "tripid": tripData.tripid,
//         "bpoint": bpoint,
//         "noofseats": selectedSeats.length,
//         "mobileno": "8305933803",
//         "email": "aadityagupta778@gmail.com",
//         "totalfare": ( selectedSeats.length * int.parse(tripData.fare.toString())).toInt()+50,
//         "bookedat": globals.selectedDate, //DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         "seatInfo": {
//           "passengerInfo": selectedPassenger
//               .map((p) => p.toJson())
//               .toList()
//         },
//         "opid": "VGT"
//       });

//         final data = response.data;

//        print("Response from confirmbooking api ----------->>>> $data");

//        return data;

//     } catch (e) {
//       print("Error in confirmTentativeBooking: $e");
//     }

//   }



}
