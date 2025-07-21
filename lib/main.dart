
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridebooking/screens/login_with_otp_screen.dart';
import 'package:ridebooking/screens/splash_screen.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'screens/seat_selection_screen.dart';

void main() {
  runApp(const BusBookingApp());
}

class BusBookingApp extends StatelessWidget {
  const BusBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hopezy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: Routes.onCreateRoute,
        initialRoute: Routes.splash,
      themeMode: ThemeMode.system, // or ThemeMode.light / dark
    );
  }
}
