// widgets/animation/floating_circles_background.dart
import 'package:flutter/material.dart';

class FloatingCirclesBackground extends StatelessWidget {
  final Animation<double> floatingAnimation;
  final BuildContext context;

   FloatingCirclesBackground({super.key, required this.floatingAnimation, required this.context});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Floating circles
          AnimatedBuilder(
            animation: floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 100 + floatingAnimation.value,
                right: 50,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 200 - floatingAnimation.value * 0.5,
                left: 30,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: floatingAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 150 + floatingAnimation.value * 0.8,
                right: 80,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              );
            },
          ),        ],
      ),
    );
  }
}
