import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridebooking/Animations/floating_circle_background_button.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_bloc.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_event.dart';
import 'package:ridebooking/bloc/loginWithOtpBloc/login_with_otp_state.dart';
import 'package:ridebooking/Animations/animated_logo.dart';
import 'package:ridebooking/commonWidgets/custom_action_button.dart';
import 'package:ridebooking/commonWidgets/email_text_field.dart';
import 'package:ridebooking/commonWidgets/mobile_number_field.dart';
import 'package:ridebooking/screens/auth/welcom_widget.dart';
import 'package:ridebooking/screens/demoscreen.dart';
import 'package:ridebooking/screens/auth/otp_verification.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_custom_theme.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class LoginWithOtpScreen extends StatefulWidget {
  const LoginWithOtpScreen({super.key});

  @override
  State<LoginWithOtpScreen> createState() => _LoginWithOtpScreenState();
}

class _LoginWithOtpScreenState extends State<LoginWithOtpScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final AnimationController _buttonController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;

  // Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _buttonScale;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  // Form and Controllers
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _focusNode = FocusNode();

  // UI State
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupControllers();
    _startAnimationSequence();
  }

  void _initializeAnimations() {

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Start continuous animations
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  void _setupControllers() {
    _mobileController.addListener(_validateForm);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateForm();
      }
    });
  }

  void _validateForm() {
    final isValid =
        _mobileController.text.length == 10 &&
        RegExp(r'^[0-9]{10}$').hasMatch(_mobileController.text);
    if (_isFormValid != isValid && mounted) {
      setState(() => _isFormValid = isValid);
    }
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _contentController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    _mobileController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      
      body: SafeArea(
        child: _buildResponsiveBody(isTablet, screenHeight, context),
      ),
    );
  }

  Widget _buildResponsiveBody(
    bool isTablet,
    double screenHeight,
    BuildContext context,
  ) {
    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea),
            AppColors.primaryBlueDark,
            AppColors.primaryBlue,
            AppColors.secondaryTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          FloatingCirclesBackground(floatingAnimation: _floatingAnimation,context: context,),
          
          // Main content
          BlocProvider(
            create: (context) => LoginWithOtpBloc(),
            child: BlocListener<LoginWithOtpBloc, LoginWithOtpState>(
              listener: _handleBlocState,
              child: BlocBuilder<LoginWithOtpBloc, LoginWithOtpState>(
                builder: (context, state) {
                  if (state is LoginWithOtpLoading) {
                    return _buildLoadingState(isTablet);
                  } else if (state is LoginWithOtpSuccess) {
                    return _buildOtpVerificationState(state, isTablet, context);
                  } else {
                    return _buildLoginForm(isTablet, screenHeight, context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Floating circles
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 100 + _floatingAnimation.value,
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
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 200 - _floatingAnimation.value * 0.5,
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
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 150 + _floatingAnimation.value * 0.8,
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
          ),
        ],
      ),
    );
  }

  void _handleBlocState(BuildContext context, LoginWithOtpState state) {
    if (state is LoginWithOtpFailure) {
      ToastMessage().showErrorToast(state.error);
      if (mounted) setState(() => _isLoading = false);
    } else if (state is OtpVerifiedState) {
      ToastMessage().showSuccessToast(
        state.message ?? 'Verification successful',
      );
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else if (state is OtpFailureState) {
      ToastMessage().showErrorToast(state.error);
    }
  }

  Widget _buildLoadingState(bool isTablet) {
    final iconSize = isTablet ? 64.0 : 48.0;
    final fontSize = isTablet ? 18.0 : 16.0;
    final containerSize = isTablet ? 220.0 : 180.0;

    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: containerSize*1.4,
              height: containerSize*1.4,
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue.withOpacity(0.1),
                          AppColors.secondaryTeal.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_outlined,
                      size: iconSize,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  Text(
                    'Sending verification code...',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpVerificationState(
    LoginWithOtpSuccess state,
    bool isTablet,
    BuildContext context,
  ) {
    return OtpVerification(
      mobileNumber: _mobileController.text,
      onCompleted: (code) {
        context.read<LoginWithOtpBloc>().add(OnOtpVerification(otp: code,email:_mobileController.text ));
      },
    );
  }

  Widget _buildLoginForm(
    bool isTablet,
    double screenHeight,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = isTablet ? screenWidth * 0.12 : 16.0;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    final isSmallScreen = screenHeight < 700;
    final headerFlex = isTablet ? 42 : (isSmallScreen ? 32 : 38);
    final formFlex = isTablet ? 58 : (isSmallScreen ? 68 : 62);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        0,
        isKeyboardVisible ? -keyboardHeight * 0.2 : 0,
        0,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // Header Section
             Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.dashboard);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
      child: Text(
        "Skip",
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
      ),
    ),
  ],
),

              Expanded(
                flex: isKeyboardVisible ? 22 : headerFlex,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isTablet ? 40 : (isSmallScreen ? 20 : 28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _logoOpacity,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: AnimatedLogo(
                                size: isTablet ? 160 : 120, 
                                padding: const EdgeInsets.all(12)
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: isTablet ? 32 : (isSmallScreen ? 16 : 20),
                      ),
                      if (!isKeyboardVisible || !isSmallScreen)
                        WelcomeSection( opacityAnimation:  _contentOpacity,slideAnimation: _contentSlide,isTablet:  isTablet,isSmallScreen:  isSmallScreen,context: context),
                    ],
                  ),
                ),
              ),

              // Form Section
              Expanded(
                flex: isKeyboardVisible ? 78 : formFlex,
                child: _buildFormContainer(
                  isTablet,
                  horizontalPadding,
                  isSmallScreen,
                  isKeyboardVisible,
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer(
    bool isTablet,
    double horizontalPadding,
    bool isSmallScreen,
    bool isKeyboardVisible,
    BuildContext context,
  ) {
    final buttonHeight = isTablet ? 58.0 : (isSmallScreen ? 48.0 : 52.0);
    final fontSize = isTablet ? 16.0 : (isSmallScreen ? 14.0 : 15.0);
    final iconSize = isTablet ? 22.0 : (isSmallScreen ? 18.0 : 20.0);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _contentController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _contentOpacity,
            child: SlideTransition(
              position: _contentSlide,
              child: Padding(
                padding: EdgeInsets.all(
                  isTablet ? 40 : (isSmallScreen ? 20 : 28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFormHeader(isTablet, isSmallScreen, context),
                    SizedBox(height: isTablet ? 32 : (isSmallScreen ? 20 : 24)),
                    _buildForm(isTablet, isSmallScreen, context),
                    SizedBox(height: isTablet ? 32 : (isSmallScreen ? 20 : 24)),
                  CustomActionButton(
  onPressed:  () => _handleSendOtp(context),//_isFormValid && !_isLoading ? : null,
  text: 'Send Code to Signup',
  height: buttonHeight,
  backgroundColor: AppColors.primaryBlue ,// _isFormValid && !_isLoading ?: Colors.grey.shade300,
  foregroundColor: _isFormValid && !_isLoading ? Colors.white : Colors.grey.shade500,
  borderColor: Colors.transparent,
  fontSize: fontSize,
  icon: Icons.send_rounded,
  iconSize: iconSize,
  isLoading: _isLoading,
  elevation: _isFormValid && !_isLoading ? 4 : 0,
  borderRadius: 16,
),
                    if (!isKeyboardVisible) ...[
                      // SizedBox(
                      //   height: isTablet ? 20 : (isSmallScreen ? 12 : 16),
                      // ),
                      // _buildSignUpLink(isTablet, isSmallScreen),
                      SizedBox(
                        height: isTablet ? 16 : (isSmallScreen ? 8 : 12),
                      ),
                      _buildFooterText(isTablet, isSmallScreen, context),



                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

 

  Widget _buildFormHeader(
    bool isTablet,
    bool isSmallScreen,
    BuildContext context,
  ) {
    final titleFontSize = isTablet ? 26.0 : (isSmallScreen ? 18.0 : 22.0);
    final subtitleFontSize = isTablet ? 16.0 : (isSmallScreen ? 13.0 : 15.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_android_rounded,
                color: AppColors.primaryBlue,
                size: isTablet ? 28 : 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Phone Verification',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 12 : (isSmallScreen ? 6 : 8)),
        Text(
          "We'll send you a secure verification code",
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(bool isTablet, bool isSmallScreen, BuildContext context) {
    return Form(
      key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          
          EmailField(controller:_mobileController ,focusNode:_focusNode ,isFormValid:_isFormValid ,isTablet:isTablet,isSmallScreen: isSmallScreen,context:context)],
      ),
    );
  }

  

  

  Widget _buildSignUpLink(bool isTablet, bool isSmallScreen) {
    final fontSize = isTablet ? 15.0 : (isSmallScreen ? 12.0 : 13.0);

    return TextButton(
      onPressed: _navigateToSignUp,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : (isSmallScreen ? 8 : 12),
          vertical: isTablet ? 10 : (isSmallScreen ? 6 : 8),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: fontSize, color: Colors.grey.shade700),
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: 'Sign up',
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText(
    bool isTablet,
    bool isSmallScreen,
    BuildContext context,
  ) {
    final fontSize = isTablet ? 12.0 : (isSmallScreen ? 9.0 : 10.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : (isSmallScreen ? 8 : 12),
      ),
      child: Text(
        'By continuing, you agree to our Terms of Service and Privacy Policy',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
          height: 1.3,
        ),
      ),
    );
  }

  void _handleSendOtp(BuildContext context) {
    // Navigator.pushNamed(context, Routes.dashboard);
     print("send code to signup ");
     context.read<LoginWithOtpBloc>().add(
        OnLoginButtonPressed(mobileNumber: _mobileController.text),
      );
    // if (_formKey.currentState?.validate() ?? false) {
    //   FocusScope.of(context).unfocus();
    //   HapticFeedback.lightImpact();

    //   setState(() => _isLoading = true);
    //   _buttonController.forward().then((_) {
    //     _buttonController.reverse();
    //   });

    //   context.read<LoginWithOtpBloc>().add(
    //     OnLoginButtonPressed(mobileNumber: _mobileController.text),
    //   );
    // } else {
    //   HapticFeedback.heavyImpact();
    //   _showErrorSnackBar('Enter valid 10-digit number');
    // }
  }

  void _navigateToSignUp() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DemoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
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
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
