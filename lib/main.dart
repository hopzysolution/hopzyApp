
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridebooking/screens/auth/login_with_otp_screen.dart';
import 'package:ridebooking/screens/splash_screen.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'screens/seat_selection_screen.dart';

void main() async{
  final apiClient = ApiClient();
  apiClient.init();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyAu22SEBAHJgM4JVaaptSAau4UOVsMSWlg",
  //         appId: "1:604780340704:android:d5f513cb2a9dff7936f785",
  //         messagingSenderId: "604780340704",
  //         projectId: "redbus-4d7c2"));

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );


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
