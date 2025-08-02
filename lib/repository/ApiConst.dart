

class ApiConst {

  // Base URL for the API
  static String baseUrl = "https://ops.vaagaibus.com/api/";

  static String baseUrl2="https://prodapi.hopzy.in/";

  static const String accessToken= "MTIxYzMyYzExNWMxMTNjOTljMTEyYzEwOGM5NWMxMDdjOTljMzJjNTZjMzJjOTVjMTEwYzEwM2M5NWMxMDFjOTljMTA4YzExNGMzMmM0MmMzMmMxMTBjOTVjMTEzYzExM2MxMTdjMTA5YzExMmM5OGMzMmM1NmMzMmM0N2M0OGM0OWMzMmMxMjNjNjQ";

  //login with otp
  static const String loginWithOtp = " ";

  //verify otp

  // static const String getStations = "GetStations/apiagent";

  static const String getAllAvailableTrips = "GetAllAvailableTripsOnADay/apiagent";

  static const String getAvailableTrips = "GetAvailableTrips/apiagent";
  static const String getAllAvailableTripsOnADay = "GetAllAvailableTripsOnADay/apiagent";

  static const String getSeatLayout= "GetSeatLayout/apiagent";

  static const String getTentativeBooking ="TentativeBooking/apiagent";

  static const String createOrder = "public/create-order";

  static const String paymentVerification ="public/verify-payment";

  static const String verifyOtp = "auth/verify-otp";

  static const String requesOtp = "auth/request-otp";

  static const String refreshTokenApi="auth/refresh-token";

  static const String confirmTentative = "ConfirmTentativeBooking/apiagent";

  static const String confirmBooking = "public/confirm-booking";



}
