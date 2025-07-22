

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/screens/Dashboard/account.dart';
import 'package:ridebooking/screens/Dashboard/dashboard_screen.dart' show DashboardScreen;
import 'package:ridebooking/screens/Dashboard/home.dart';
import 'package:ridebooking/screens/Dashboard/master_list.dart';
import 'package:ridebooking/screens/Dashboard/tickets.dart';
import 'package:ridebooking/screens/auth/login_with_otp_screen.dart';
import 'package:ridebooking/screens/auth/otp_verification.dart';
import 'package:ridebooking/screens/splash_screen.dart';



class Routes {
  // static const String login = "/login";
  static const String splash = "/splash_screen";
  static const String userInfo = "/user_info";


  
  // Authentication routes
  static const String otpVerification = "/otp_verification";
  static const String loginWithOtpScreen = "/login_with_otp_screen";
  static const String demoScreen="/demoscreen";
  static const String masterList = "/master_list";
  static const String home = "/home";
  static const String tickets = "/tickets";
  static const String account = "/account";
  static const String dashboard = "/dashboard_screen";



  static Route<dynamic>? onCreateRoute(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) {
          return  SplashScreen();
        });

        case loginWithOtpScreen:
        return MaterialPageRoute(builder: (context) {
          return LoginWithOtpScreen();
        });

        case otpVerification:
        return MaterialPageRoute(builder: (context) {
          return OtpVerification();
        });

        case dashboard:
        return MaterialPageRoute(builder: (context) {
          return DashboardScreen();
        });

        case home:
        return MaterialPageRoute(builder: (context) {
          return Home();
        });
        case tickets:
        return MaterialPageRoute(builder: (context) {
          return Tickets();
        });
        case masterList:
        return MaterialPageRoute(builder: (context) {
          return MasterList();
        });
        case account:
        return MaterialPageRoute(builder: (context) {
          return Account();
        });

       

     


      default:
        return null;
    }
  }
}
