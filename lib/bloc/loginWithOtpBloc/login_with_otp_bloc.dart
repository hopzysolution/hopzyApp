import 'package:bloc/bloc.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_event.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_state.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/session.dart';

class LoginWithOtpBloc extends Bloc<LoginWithOtpEvent,LoginWithOtpState> {
  String? mobileNumber;

   final api = ApiClient();
  LoginWithOtpBloc() : super(LoginWithOtpInitial()) {
   on<OnLoginButtonPressed>((event, emit) async {

       print("Request Otp button clicked bloc ");
      mobileNumber = event.mobileNumber;


      emit(LoginWithOtpLoading());
      
                  

// Request OTP

       ApiResponse response  = await api.requestOtp(event.mobileNumber!.contains("+91")?event.mobileNumber!:"+91${event.mobileNumber!}");
  // var response =await ApiRepository.postAPI(ApiConst.loginWithOtp, formData);
       await Session().setPhoneNo(mobileNumber!.contains("+91")?mobileNumber!:"+91${mobileNumber!}");
        if( response==null) {emit(LoginWithOtpFailure(error: "Server error data not found"));}else{
           print("Api response in bloc ========>>>>${response.data}");
  // Map<String, dynamic> parsed = json.decode(response.data.toString());

      if (response.data.toString().contains("status")) {
        if (response.data['status'] == 1) {
          // Handle successful login
          emit(LoginWithOtpSuccess(message: response.data['message']));
        } else {
          // Handle login failure
          emit(LoginWithOtpFailure(error: response.data['message']));
        }
      } else {
        // Handle unexpected response format
        print("error in response format: ${response.toString()}");
        emit(LoginWithOtpFailure(error: "Unexpected response format--->>>"));
      }


      
        }
    });

     on<OnSignupButtonPressed>((event, emit) async {
       print("Request Otp button clicked bloc ");
      mobileNumber = event.mobileNumber;

      emit(LoginWithOtpLoading());
   
// Request OTP
       ApiResponse response  = await api.registerUser(event.firstName!,event.lastName!, mobileNumber!.contains("+91")?mobileNumber!:"+91${mobileNumber!}");
  // var response =await ApiRepository.postAPI(ApiConst.loginWithOtp, formData);
        await Session().setPhoneNo(mobileNumber!.contains("+91")?mobileNumber!:"+91${mobileNumber!}");
        if( response==null) {
          emit(LoginWithOtpFailure(error: "Server error data not found"));
          }else{
           print("Api response in bloc ========>>>>${response.data}");
  // Map<String, dynamic> parsed = json.decode(response.data.toString());

      if (response.data.toString().contains("status")) {
        if (response.data['status'] == 1) {
          // Handle successful login
          emit(LoginWithOtpSuccess(message: response.data['message']));
        } else {
          // Handle login failure
          emit(LoginWithOtpFailure(error: response.data['message']));
        }
      } else {
        // Handle unexpected response format
        print("error in response format: ${response.toString()}");
        emit(LoginWithOtpFailure(error: "Unexpected response format--->>>"));
      }


      
        }
    });

    // Otp verification event

    on<OnOtpVerification>((event, emit) async {
      // Handle OTP verification logic here
      print("Otp verification event triggered with OTP: ${event.otp}");
      emit(LoginWithOtpLoading());
      
      // var response = await ApiRepository.postAPI(ApiConst.verifyOtp, formData);
      // Verify OTP
        ApiResponse response = await api.verifyOtp(event.email, event.otp);
            print("Tokens saved------->>>: ${response!.data}");
      // Map<String, dynamic> parsed = json.decode(response.data.toString());

      if (response.data.toString().contains("status")) {
        if (response.data['status'] == 1) {
           print("--------  result  -->>>>>>>>>${response.data.toString()}");
          // Handle successful OTP verification
          emit(OtpVerifiedState(message: "User Logged In Successfully"));
        } else {
          // Handle OTP verification failure
          emit(OtpFailureState(error: response.data['message']));
        }
      } else {
        // Handle unexpected response format
        emit(LoginWithOtpFailure(error: "Unexpected response format"));
      }
    });


  }
}