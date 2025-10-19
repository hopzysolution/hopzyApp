
import 'package:ridebooking/globels.dart' as globals;

class ApiConst {

  // Base URL for the API
  // static String baseUrl = "https://ops.vaagaibus.com/api/";

  static String baseUrl = "https://api.vaagaibus.in/api/";

  

  static String baseUrl2= "https://prodapi.hopzy.in/";//"https://stagingapi.hopzy.in/";//"

  // static const String accessToken= "MTIxYzMyYzExNWMxMTNjOTljMTEyYzEwOGM5NWMxMDdjOTljMzJjNTZjMzJjOTVjMTEwYzEwM2M5NWMxMDFjOTljMTA4YzExNGMzMmM0MmMzMmMxMTBjOTVjMTEzYzExM2MxMTdjMTA5YzExMmM5OGMzMmM1NmMzMmM0N2M0OGM0OWMzMmMxMjNjNjQ";

  static const String accessToken = "MTE1YzI2YzEwOWMxMDdjOTNjMTA2YzEwMmM4OWMxMDFjOTNjMjZjNTBjMjRjMjZjOTZjMTAzYzEwNGMxMTRjMTEzYzEwN2MxMDBjMjZjMzZjMjZjMTA0Yzg5YzEwN2MxMDdjMTExYzEwM2MxMDZjOTJjMjZjNTBjMjZjNjRjMTAzYzc1YzEwM2M0MmMxMDRjMTA4YzQ5YzI2YzExN2M3MA==";

  //login with otp
  static const String loginWithOtp = "";

  //verify otp

  // static const String getStations = "GetStations/apiagent";

  //getOperatorList 
  static const String getOperatorList = "GetOperatorList/hopzy";
  

  static const String getAllAvailableTrips = "GetAllAvailableTripsOnADay/apiagent";

  static const String getAvailableTrips = "api/public/trips"; //"GetAvailableTrips/apiagent";
  static const String getAllAvailableTripsOnADay = "GetAllAvailableTripsOnADay/apiagent";

  static const String getSeatLayout= "api/public/layout" ;//"GetSeatLayout/apiagent";

  static const String getProfileApi="api/public/get-profile";

  static const String getTentativeBooking ="api/public/tentativeBooking";

  static const String cancelBooking = "api/public/cancelBooking";
  static const String confirmCancelBooking = "api/public/confirmCancelBooking";//"ConfirmCancel/apiagent";
  static const String cancelHopzyBooking="api/private/bookings/cancel";

  static const String createOrder = "api/public/create-order";
  static const String paymentVerification = "api/public/payu/success";//"api/public/verify-payment";
  static const String verifyOtp = "api/auth/verify-otp";
  static const String requesOtp = "api/auth/request-otp";
  static const String refreshTokenApi="api/auth/refresh-token";
  static const String confirmBooking = "api/public/confirm-booking";
  static const String getUserBookings = "api/private/user/bookings?limit=500&page=1";//&phone=%2B{phoneNumber}";
  static const String registerUser = "api/auth/register";

  static const String confirmTentative = "api/public/confirmBookingFromTentative";
//ticket details
  static const String ticketDetails ="GetTicketAllInfo/apiagent";


  static const String bookingTicketDetails="api/public/bookings/{ticketId}";


//



}
