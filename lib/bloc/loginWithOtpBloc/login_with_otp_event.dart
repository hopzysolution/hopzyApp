import 'package:flutter/material.dart';

abstract class LoginWithOtpEvent {}

class OnLoginButtonPressed extends LoginWithOtpEvent {
   String? mobileNumber;

  OnLoginButtonPressed({required this.mobileNumber});
}

class OnOtpVerification extends LoginWithOtpEvent {
  String otp;

  OnOtpVerification({required this.otp});
}

class OnSignWithGoogle extends LoginWithOtpEvent {
  BuildContext context;
  OnSignWithGoogle({required this.context});
}

