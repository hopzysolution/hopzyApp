
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:ridebooking/utils/Api_client.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/route_generate.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await MediaStore.ensureInitialized();
   MediaStore.appFolder = "Hopzy";
  final apiClient = ApiClient();
  apiClient.init();
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
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
