import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridebooking/commonWidgets/custom_bottom_nav_bar.dart';
import 'package:ridebooking/screens/Dashboard/account.dart';
import 'package:ridebooking/screens/Dashboard/home_screen.dart';
import 'package:ridebooking/screens/Dashboard/master_list.dart';
import 'package:ridebooking/screens/Dashboard/tickets.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:ridebooking/screens/webview_pages/webview_pages_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String fullName = "";
  bool _isLoading = true;
  
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  final List<Widget> _pages = [
   HomeScreen(),
    //  Tickets(),
    WebViewPagesScreenBody(
      titleMain: "AI",
      urlToLoad: "https://www.google.com",
      bodyTags: "",
    ),
   MasterList(),
   Account()
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadUserData() async {
    try {
      final name = await Session().getFullName();
      
      if (mounted) {
        setState(() {
          fullName = name.isNotEmpty ? name : 'Welcome User';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          fullName = "Welcome User";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedIndex = index;
      });
      
      if (index == 3) {
        _fabAnimationController.forward().then((_) {
          _fabAnimationController.reverse();
        });
      }
    }
  }

  void _onDrawerItemTap(String title) {
    Navigator.pop(context);
    HapticFeedback.selectionClick();
    
    _showSnackBar('Tapped $title', isError: false);
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isTablet),
      drawer: _buildDrawer(isTablet),
      body: _isLoading ? _buildLoadingState(isTablet) : _buildBody(), 
      bottomNavigationBar: CustomBottomNavBar(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      isTablet: isTablet,
    ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isTablet) {
    final titleFontSize = isTablet ? 22.0 : 18.0;
    final iconSize = isTablet ? 26.0 : 22.0;
    final walletFontSize = isTablet ? 16.0 : 14.0;

    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: isTablet ? 70 : 56,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 8 : 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
                'assets/images/ticket.png',
                width: isTablet ? 20 : 18,
                height: isTablet ? 20 : 18,
              )
            // Icon(
            //   Icons.location_on_rounded,
            //   color: Colors.white,
            //   size: isTablet ? 20 : 18,
            // ),
          ),
          SizedBox(width: isTablet ? 12 : 8),
          Text(
            'Bus Tickets',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        // Container(
        //   margin: EdgeInsets.only(right: isTablet ? 16 : 12),
        //   padding: EdgeInsets.symmetric(
        //     horizontal: isTablet ? 16 : 12,
        //     vertical: isTablet ? 8 : 6,
        //   ),
        //   decoration: BoxDecoration(
        //     color: Colors.white.withOpacity(0.15),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(
        //       color: Colors.white.withOpacity(0.3),
        //       width: 1,
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(
        //         Icons.account_balance_wallet_rounded,
        //         color: Colors.white,
        //         size: isTablet ? 18 : 16,
        //       ),
        //       SizedBox(width: isTablet ? 8 : 6),
        //       Text(
        //         '₹ 0',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //           fontSize: walletFontSize,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isTablet ? 40 : 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isTablet ? 32 : 24,
              height: isTablet ? 32 : 24,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: _pages,
    );
  }

  Widget _buildDrawer(bool isTablet) {
    final avatarRadius = isTablet ? 50.0 : 45.0;
    final headerHeight = isTablet ? 240.0 : 220.0;
    final nameFontSize = isTablet ? 24.0 : 20.0;
    final subtitleFontSize = isTablet ? 16.0 : 14.0;

    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Enhanced Header
            Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlueDark,
                    AppColors.primaryBlue,
                   AppColors.secondaryTeal,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 24 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: avatarRadius - 3,
                          backgroundImage: const AssetImage("assets/images/HopzybluePin.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    Text(
                      fullName.isNotEmpty ? fullName : 'Welcome User',
                      style: TextStyle(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: isTablet ? 12 : 8),

            // Menu Items with Categories
            _buildSectionHeader('My details', isTablet),
            _buildModernListTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Bookings',
              onTap: () => _onDrawerItemTap("MyOrders"),
              isTablet: isTablet,
            ),
            _buildModernListTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Personal information',
              onTap: () => _onDrawerItemTap("MyWallet"),
              isTablet: isTablet,
            ),
            _buildModernListTile(
              icon: Icons.loyalty_outlined,
              title: 'Passengers',
              onTap: () => _onDrawerItemTap("LoyaltyHistory"),
              isTablet: isTablet,
            ),
            _buildModernListTile(
              icon: Icons.loyalty_outlined,
              title: 'IRCTC details',
              onTap: () => _onDrawerItemTap("LoyaltyHistory"),
              isTablet: isTablet,
            ),

            _buildSectionHeader('Payments', isTablet),
            _buildModernListTile(
              icon: Icons.wallet,
              title: 'redBus Wallet',
              onTap: () => _onDrawerItemTap("MyQuestions"),
              isTablet: isTablet,
            ),
           

            SizedBox(height: isTablet ? 20 : 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey.shade300,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),

            // Logout with special styling
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 12 : 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100),
                color: Colors.red.shade50.withOpacity(0.3),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(isTablet ? 10 : 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: isTablet ? 22 : 20,
                  ),
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 16 : 15,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.redAccent.withOpacity(0.7),
                  size: isTablet ? 22 : 20,
                ),
                onTap: () => _onDrawerItemTap("Logout"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 8 : 4,
                ),
              ),
            ),

            SizedBox(height: isTablet ? 24 : 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isTablet ? 28 : 24,
        isTablet ? 20 : 16,
        isTablet ? 28 : 24,
        isTablet ? 12 : 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 14 : 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModernListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 3 : 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primaryBlue.withOpacity(0.1),
          highlightColor: AppColors.primaryBlue.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 16,
              vertical: isTablet ? 16 : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.7),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 10 : 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryBlue,
                    size: isTablet ? 22 : 20,
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: isTablet ? 22 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildBottomNavigationBar(bool isTablet) {
  //   final navHeight = isTablet ? 90.0 : 80.0;
  //   final fabSize = isTablet ? 70.0 : 60.0;

  //   return Container(
  //     height: navHeight,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           offset: const Offset(0, -2),
  //           blurRadius: 15,
  //           spreadRadius: 0,
  //         ),
  //       ],
  //     ),
  //     child: Stack(
  //       children: [
  //         // Main Bottom Navigation
  //         // Row(
  //         //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         //   children: [
  //         //     _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home', isTablet),
  //         //     _buildNavItem(1, Icons.chat_bubble_outline, Icons.chat_bubble_rounded, 'Tickets', isTablet),
  //         //     _buildNavItem(2, Icons.help_outline, Icons.help_rounded, 'Master List', isTablet),
  //         //     // SizedBox(width: isTablet ? 40 : 30),
  //         //     _buildNavItem(4, Icons.music_note_outlined, Icons.music_note_rounded, 'Account', isTablet),
  //         //     // _buildNavItem(5, Icons.auto_fix_high_outlined, Icons.auto_fix_high_rounded, 'Kundli', isTablet),
  //         //   ],
  //         // ),

  //         // Elevated Center Button (3D Try On)
  //         // Positioned(
  //         //   top: isTablet ? 5 : 0,
  //         //   left: MediaQuery.of(context).size.width / 2 - (fabSize / 2),
  //         //   child: AnimatedBuilder(
  //         //     animation: _fabAnimationController,
  //         //     builder: (context, child) {
  //         //       return ScaleTransition(
  //         //         scale: _fabScaleAnimation,
  //         //         child: RotationTransition(
  //         //           turns: _fabRotationAnimation,
  //         //           child: GestureDetector(
  //         //             onTap: () => _onItemTapped(3),
  //         //             child: Container(
  //         //               width: fabSize,
  //         //               height: fabSize,
  //         //               decoration: BoxDecoration(
  //         //                 gradient: const LinearGradient(
  //         //                   begin: Alignment.topLeft,
  //         //                   end: Alignment.bottomRight,
  //         //                   colors: [
  //         //                     Color.fromARGB(255, 250, 103, 5),
  //         //                     Color.fromARGB(255, 255, 140, 40),
  //         //                     Color.fromARGB(255, 240, 90, 0),
  //         //                   ],
  //         //                 ),
  //         //                 borderRadius: BorderRadius.circular(fabSize / 2),
  //         //                 boxShadow: [
  //         //                   BoxShadow(
  //         //                     color: const Color.fromARGB(255, 250, 103, 5).withOpacity(0.4),
  //         //                     offset: const Offset(0, 6),
  //         //                     blurRadius: 16,
  //         //                     spreadRadius: 2,
  //         //                   ),
  //         //                   BoxShadow(
  //         //                     color: Colors.black.withOpacity(0.2),
  //         //                     offset: const Offset(0, 3),
  //         //                     blurRadius: 10,
  //         //                     spreadRadius: 0,
  //         //                   ),
  //         //                 ],
  //         //               ),
  //         //               child: Stack(
  //         //                 children: [
  //         //                   // Inner highlight for 3D effect
  //         //                   Container(
  //         //                     width: fabSize,
  //         //                     height: fabSize,
  //         //                     decoration: BoxDecoration(
  //         //                       borderRadius: BorderRadius.circular(fabSize / 2),
  //         //                       gradient: LinearGradient(
  //         //                         begin: Alignment.topCenter,
  //         //                         end: Alignment.bottomCenter,
  //         //                         colors: [
  //         //                           Colors.white.withOpacity(0.3),
  //         //                           Colors.transparent,
  //         //                           Colors.black.withOpacity(0.1),
  //         //                         ],
  //         //                       ),
  //         //                     ),
  //         //                   ),
  //         //                   // Icon and Label
  //         //                   Center(
  //         //                     child: Column(
  //         //                       mainAxisAlignment: MainAxisAlignment.center,
  //         //                       children: [
  //         //                         Icon(
  //         //                           _selectedIndex == 3 ? Icons.view_in_ar_rounded : Icons.view_in_ar_outlined,
  //         //                           color: Colors.white,
  //         //                           size: isTablet ? 28 : 24,
  //         //                           shadows: [
  //         //                             Shadow(
  //         //                               offset: const Offset(0, 2),
  //         //                               blurRadius: 4,
  //         //                               color: Colors.black.withOpacity(0.3),
  //         //                             ),
  //         //                           ],
  //         //                         ),
  //         //                         SizedBox(height: isTablet ? 4 : 2),
  //         //                         Text(
  //         //                           '3D',
  //         //                           style: TextStyle(
  //         //                             color: Colors.white,
  //         //                             fontSize: isTablet ? 11 : 9,
  //         //                             fontWeight: FontWeight.w600,
  //         //                             shadows: [
  //         //                               Shadow(
  //         //                                 offset: const Offset(0, 1),
  //         //                                 blurRadius: 2,
  //         //                                 color: Colors.black.withOpacity(0.3),
  //         //                               ),
  //         //                             ],
  //         //                           ),
  //         //                         ),
  //         //                       ],
  //         //                     ),
  //         //                   ),
  //         //                 ],
  //         //               ),
  //         //             ),
  //         //           ),
  //         //         ),
  //         //       );
  //         //     },
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // // Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label, bool isTablet) {
  //   bool isSelected = _selectedIndex == index;
  //   final iconSize = isTablet ? 24.0 : 20.0;
  //   final labelFontSize = isTablet ? 12.0 : 10.0;

  //   return GestureDetector(
  //     onTap: () => _onItemTapped(index),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //         vertical: isTablet ? 12 : 8,
  //         horizontal: isTablet ? 16 : 12,
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           AnimatedContainer(
  //             duration: const Duration(milliseconds: 200),
  //             padding: EdgeInsets.all(isTablet ? 8 : 6),
  //             decoration: BoxDecoration(
  //               color: isSelected 
  //                   ? const Color.fromARGB(255, 250, 103, 5).withOpacity(0.15)
  //                   : Colors.transparent,
  //               borderRadius: BorderRadius.circular(16),
  //               border: isSelected 
  //                   ? Border.all(
  //                       color: const Color.fromARGB(255, 250, 103, 5).withOpacity(0.3),
  //                       width: 1,
  //                     )
  //                   : null,
  //             ),
  //             child: Icon(
  //               isSelected ? selectedIcon : unselectedIcon,
  //               color: isSelected 
  //                   ? const Color.fromARGB(255, 250, 103, 5)
  //                   : Colors.grey.shade600,
  //               size: iconSize,
  //             ),
  //           ),
  //           SizedBox(height: isTablet ? 6 : 4),
  //           AnimatedDefaultTextStyle(
  //             duration: const Duration(milliseconds: 200),
  //             style: TextStyle(
  //               color: isSelected 
  //                   ? const Color.fromARGB(255, 250, 103, 5)
  //                   : Colors.grey.shade600,
  //               fontSize: labelFontSize,
  //               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  //             ),
  //             child: Text(label),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}