import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_event.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_state.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
class LoginWithOtpBloc extends Bloc<LoginWithOtpEvent,LoginWithOtpState> {
  String? mobileNumber;
  LoginWithOtpBloc() : super(LoginWithOtpInitial()) {
    on<OnLoginButtonPressed>((event, emit) async {
      mobileNumber = event.mobileNumber;
      // Here you can handle the login logic
      // For example, call an API to verify the mobile number
      // and emit the appropriate state based on the response.
      emit(LoginWithOtpLoading());
      var formData={
    "countryCode": "+91",
    "mobileNumber": mobileNumber,//"8659868689",
    "newUser": false,
    "astroUser": false,
    "firstName": "",
    "lastName": "",
    "verificationId":"fe4c1e2a-60fb-4fa4-8c5e-eb2f4d33bff1",// await Session.getDeviceId()
                   };
  var response =await ApiRepository.postAPI(ApiConst.loginWithOtp, formData);

  Map<String, dynamic> parsed = json.decode(response.toString());

      if (response.toString().contains("statusCode")) {
        if (parsed['statusCode'] == 200) {
          // Handle successful login
          emit(LoginWithOtpSuccess(message: parsed['message']));
        } else {
          // Handle login failure
          emit(LoginWithOtpFailure(error: parsed['message']));
        }
      } else {
        // Handle unexpected response format
        print("error in response format: ${response.toString()}");
        emit(LoginWithOtpFailure(error: "Unexpected response format--->>>"));
      }


      
      
    });

    // Otp verification event

    on<OnOtpVerification>((event, emit) async {
      // Handle OTP verification logic here
      print("Otp verification event triggered with OTP: ${event.otp}");
      emit(LoginWithOtpLoading());
      var formData = {
    "countryCode": "+91",
    "mobileNumber": mobileNumber,
    "verificationId":"fe4c1e2a-60fb-4fa4-8c5e-eb2f4d33bff1",// await Session.getDeviceId(),
    "otpCode": event.otp, 
  };
      var response = await ApiRepository.postAPI(ApiConst.verifyOtp, formData);

      Map<String, dynamic> parsed = json.decode(response.toString());

      if (response.toString().contains("statusCode")) {
        if (parsed['statusCode'] == 200) {
           print("--------  result  -->>>>>>>>>${response.toString()}");
          // Handle successful OTP verification
          emit(OtpVerifiedState(message: "User Logged In Successfully"));
        } else {
          // Handle OTP verification failure
          emit(OtpFailureState(error: parsed['message']));
        }
      } else {
        // Handle unexpected response format
        emit(LoginWithOtpFailure(error: "Unexpected response format"));
      }
    });


  }
}