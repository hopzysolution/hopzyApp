import 'package:circle_nav_bar/circle_nav_bar.dart';
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
    return
    //  Container(
    //   height: isTablet ? 100.0 : 75.0,
    //   decoration: BoxDecoration(
    //     color: Colors.transparent,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.1),
    //         offset: const Offset(0, -4),
    //         blurRadius: 20,
    //       ),
    //     ],
    //   ),
    //   child:
    Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child:
          // bottomNavigationBar:
          CircleNavBar(
            activeIndex: selectedIndex,
            onTap: onItemTapped,
            circleColor: AppColors.primaryBlue,
            // 🎯 Dynamic sizing
            height: MediaQuery.of(context).size.height * 0.09,        // ~70 on normal devices
            circleWidth:MediaQuery.of(context).size.width * 0.14,
            activeLevelsStyle: TextStyle(
              color: Colors.white
            ),
            inactiveLevelsStyle: TextStyle(
                color: Colors.white
            ),


            levels: ["Home", "Booking", "Tickets", "Account"],
            // circlePadding: const EdgeInsets.only(top: 5),
            activeIcons: [
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                alignment: Alignment.center,
                child: const Icon(Icons.home, color: Colors.white, size: 25),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.list_alt_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.airplane_ticket,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
            inactiveIcons: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.home, color: Colors.white, size: 22),
              ),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.list_alt_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.airplane_ticket,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
            color:
                // Colors.blueAccent,
                AppColors.primaryBlue,
          ),

      // GNav(
      //   selectedIndex: selectedIndex,
      //   onTabChange: onItemTapped,
      //   rippleColor: AppColors.neutral100.withOpacity(0.4),
      //   hoverColor: AppColors.primaryBlue,
      //   haptic: true,
      //   tabBorderRadius: 15,
      //   tabActiveBorder: Border.all(color: AppColors.primaryBlue, width: 1.5),
      //   tabBorder: Border.all(color: Colors.transparent, width: 1),
      //   // tabShadow: [
      //   //   BoxShadow(
      //   //     color: Colors.black12,
      //   //     blurRadius: 6,
      //   //     offset: Offset(0, 2),
      //   //   )
      //   // ],
      //   curve: Curves.easeOutExpo,
      //   duration: const Duration(milliseconds: 600),
      //   gap: 8,
      //   color: AppColors.neutral100,
      //   activeColor: AppColors.neutral100,
      //   iconSize: 24,
      //   tabBackgroundColor: AppColors.neutral900,
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //   tabs: const [
      //     GButton(
      //       iconColor: AppColors.neutral100,
      //       iconActiveColor: AppColors.primaryBlue,
      //       icon: Icons.home,
      //       text: 'Home',

      //     ),
      //     GButton(
      //       iconColor: AppColors.neutral100,
      //       iconActiveColor: AppColors.primaryBlue,
      //       icon: Icons.list_alt_rounded,
      //       text: 'Bookings',
      //     ),
      //     GButton(
      //       iconColor: AppColors.neutral100,
      //       iconActiveColor: AppColors.primaryBlue,
      //       icon: Icons.airplane_ticket,
      //       text: 'Tickets',
      //     ),
      //     GButton(
      //       iconColor: AppColors.neutral100,
      //       iconActiveColor: AppColors.primaryBlue,
      //       icon: Icons.account_circle_rounded,
      //       text: 'Account',
      //     ),
      //   ],
      // ),
    );
  }
}
