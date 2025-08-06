import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final BuildContext context;
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;
  final bool isTablet;
  final bool isSmallScreen;

  const WelcomeSection({
    super.key,
    required this.context,
    required this.opacityAnimation,
    required this.slideAnimation,
    required this.isTablet,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isTablet ? 36.0 : (isSmallScreen ? 24.0 : 28.0);
    final subtitleFontSize = isTablet ? 18.0 : (isSmallScreen ? 14.0 : 16.0);

    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 3),
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: isTablet ? 16 : (isSmallScreen ? 5 : 8)),
            Text("Enter your email to continue your journey",
              // 'Enter your mobile number to continue your journey',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.95),
                // height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
