abstract class LoginWithOtpState {}

class LoginWithOtpInitial extends LoginWithOtpState {}
class LoginWithOtpLoading extends LoginWithOtpState {}
class LoginWithOtpSuccess extends LoginWithOtpState {
  final String? message;

  LoginWithOtpSuccess({this.message});
}

class LoginWithOtpFailure extends LoginWithOtpState {
  final String error;

  LoginWithOtpFailure({required this.error});
}
class OtpVerifiedState extends LoginWithOtpState {
  final String? message;

  OtpVerifiedState({this.message});

}

class OtpFailureState extends LoginWithOtpState {
  final String error;

  OtpFailureState({required this.error});
}

