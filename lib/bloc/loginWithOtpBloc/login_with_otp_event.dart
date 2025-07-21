abstract class LoginWithOtpEvent {}

class OnLoginButtonPressed extends LoginWithOtpEvent {
   String? mobileNumber;

  OnLoginButtonPressed({required this.mobileNumber});
}

class OnOtpVerification extends LoginWithOtpEvent {
  String otp;

  OnOtpVerification({required this.otp});
}

