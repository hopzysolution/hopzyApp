import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ridebooking/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isTablet;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isTablet ? 100.0 : 85.0,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: GNav(
          selectedIndex: selectedIndex,
          onTabChange: onItemTapped,
          rippleColor: AppColors.neutral100.withOpacity(0.4),
          hoverColor: AppColors.primaryBlue,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: AppColors.primaryBlue, width: 1.5),
          tabBorder: Border.all(color: Colors.transparent, width: 1),
          // tabShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 6,
          //     offset: Offset(0, 2),
          //   )
          // ],
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 600),
          gap: 8,
          color: AppColors.neutral100,
          activeColor: AppColors.neutral100,
          iconSize: 24,
          tabBackgroundColor: AppColors.neutral100.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabs: const [
            GButton(
              iconColor: AppColors.neutral100,
              iconActiveColor: AppColors.primaryBlue,
              icon: Icons.home,
              text: 'Home',
              
            ),
            GButton(
              iconColor: AppColors.neutral100,
              iconActiveColor: AppColors.primaryBlue,
              icon: Icons.list_alt_rounded,
              text: 'Bookings',
            ),
            GButton(
              iconColor: AppColors.neutral100,
              iconActiveColor: AppColors.primaryBlue,
              icon: Icons.airplane_ticket,
              text: 'Tickets',
            ),
            GButton(
              iconColor: AppColors.neutral100,
              iconActiveColor: AppColors.primaryBlue,
              icon: Icons.account_circle_rounded,
              text: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}


