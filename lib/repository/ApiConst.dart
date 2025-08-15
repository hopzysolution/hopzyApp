

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

  static const String cancelBooking = "Cancel/apiagent";
  static const String confirmCancelBooking = "ConfirmCancel/apiagent";

  static const String createOrder = "api/public/create-order";
  static const String paymentVerification ="api/public/verify-payment";
  static const String verifyOtp = "api/auth/verify-otp";
  static const String requesOtp = "api/auth/request-otp";
  static const String refreshTokenApi="api/auth/refresh-token";
  static const String confirmBooking = "api/public/confirm-booking";
  static const String getUserBookings = "api/private/user/bookings?page=1&limit=10";

  static const String confirmTentative = "ConfirmTentativeBooking/apiagent";
//ticket details
  static const String ticketDetails ="GetTicketAllInfo/apiagent";

  static const String cancelHopzyBooking="api/private/bookings/cancel";



}
