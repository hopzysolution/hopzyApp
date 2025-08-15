import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ridebooking/screens/demoscreen.dart';
import 'package:ridebooking/screens/auth/login_with_otp_screen.dart';
import 'package:ridebooking/screens/new_bus_seat_layout.dart';
import 'package:ridebooking/screens/trip_details_screen.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _zoomController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Color?> _backgroundColorAnimation;

  final Color _targetColor = const Color(
    0xFF007BFF,
  ); // Example: Blue (match your logo)

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 25.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    _backgroundColorAnimation =
        ColorTween(begin: Colors.white, end: _targetColor).animate(
          CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
        );

    // Start zoom after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _zoomController.forward();
    });

    // Navigate after zoom finishes
    _zoomController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        callNextPage();
      }
    });
  }

  callNextPage() async {
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SeatLayoutScreen()));
    String token = await Session().getToken();
    if (token.isNotEmpty)
      Navigator.pushReplacementNamed(

        context,
        Routes.dashboard, // Navigate to Login with OTP screen
      );
    else {
      Navigator.pushReplacementNamed(context, Routes.loginWithOtpScreen);
    }
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _zoomController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,
          body: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Image.asset(
                'assets/images/HopzybluePin.png', // Your logo
                width: 180,
                height: 180,
              ),
            ),
          ),
        );
      },
      child: const SizedBox(),
    );
  }
}
