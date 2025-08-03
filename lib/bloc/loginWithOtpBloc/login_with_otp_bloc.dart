import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_event.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_state.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/repository/ApiRepository.dart';
import 'package:ridebooking/services/firebase_methods.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/session.dart';
class LoginWithOtpBloc extends Bloc<LoginWithOtpEvent,LoginWithOtpState> {
  String? mobileNumber;

   final api = ApiClient();
  LoginWithOtpBloc() : super(LoginWithOtpInitial()) {


    //   on<OnSignWithGoogle>((event, State) async {
    //   emit(LoginWithOtpInitial());
    //   Session preferenceHelper = Session();
    //   String? name = await preferenceHelper.getFullName();
    //   if (name == null || name.isEmpty) {
    //     try {
    //       FirebaseMethods().signInWithGoogle(event.context);
    //     } catch (e) {
    //       print("Exception in signInWithGoogle ----> ${e}");
    //     }
    //   } else {
    //     Navigator.pushReplacementNamed(event.context, Routes.homeScreen);
    //   }
    // });






    on<OnLoginButtonPressed>((event, emit) async {
      mobileNumber = event.mobileNumber;
      // Here you can handle the login logic
      // For example, call an API to verify the mobile number
      // and emit the appropriate state based on the response.
      emit(LoginWithOtpLoading());
      
                  

// Request OTP
       var response  = await api.requestOtp(event.mobileNumber!);
  // var response =await ApiRepository.postAPI(ApiConst.loginWithOtp, formData);

  Map<String, dynamic> parsed = json.decode(response.toString());

      if (response.toString().contains("status")) {
        if (parsed['status'] == 1) {
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
      
      // var response = await ApiRepository.postAPI(ApiConst.verifyOtp, formData);
      // Verify OTP
        var response = await api.verifyOtp(event.email, event.otp);
            print("Tokens saved------->>>: ${response.data}");
      Map<String, dynamic> parsed = json.decode(response.toString());

      if (response.toString().contains("status")) {
        if (parsed['status'] == 1) {
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