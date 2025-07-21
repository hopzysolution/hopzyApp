import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ridebooking/screens/demoscreen.dart';
import 'package:ridebooking/screens/login_with_otp_screen.dart';
import 'package:ridebooking/utils/route_generate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _zoomController;
  late final AnimationController _jogTextController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Color?> _backgroundColorAnimation;

  final Color _targetColor = const Color(0xFF007BFF); // Example: Blue (match your logo)

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _jogTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 25.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: _targetColor,
    ).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    // Start zoom after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _zoomController.forward();
    });

    // Navigate after zoom finishes
    _zoomController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(
          context,Routes.loginWithOtpScreen, // Navigate to Login with OTP screen
        );
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _jogTextController.dispose();
    super.dispose();
  }

  Matrix4 _jogTransform(double value) {
    return Matrix4.translationValues(
      10 * sin(2 * pi * value),
      5 * cos(2 * pi * value),
      0,
    )..rotateZ(0.05 * sin(2 * pi * value));
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
                width: 100,
                height: 100,
              ),
            ),
          ),
        );
      },
      child: const SizedBox(),
    );
  }
}
