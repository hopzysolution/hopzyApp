import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridebooking/Animations/animated_logo.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/toast_messages.dart';

class OtpVerification extends StatefulWidget {
  final Function(String code)? onCompleted;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;

  const OtpVerification({
    Key? key, 
    this.onCompleted,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> 
    with TickerProviderStateMixin {
  // Controllers and Focus Nodes
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  // Animation Controllers
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  
  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  
  // Timer and State
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListeners();
    _startCountdown();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          HapticFeedback.selectionClick();
        }
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _timer?.cancel();
    
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isNotEmpty) {
      HapticFeedback.lightImpact();
      
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
        _verifyOtp();
      }
    }
  }

  void _onKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        HapticFeedback.selectionClick();
      }
    }
  }

  void _verifyOtp() {
    String finalInput = _controllers.map((e) => e.text).join();
    if (finalInput.length == 6) {
      setState(() => _isVerifying = true);
      HapticFeedback.mediumImpact();
      
      // Simulate verification delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isVerifying = false);
          widget.onCompleted?.call(finalInput);
        }
      });
    } else {
      _triggerShakeAnimation();
    }
  }

  void _triggerShakeAnimation() {
    HapticFeedback.heavyImpact();
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  void _startCountdown() {
    if (_timer != null && _timer!.isActive) return;

    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
        HapticFeedback.selectionClick();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resendOtp() {
    HapticFeedback.mediumImpact();
    _startCountdown();
    
    // Clear existing input
    for (var controller in _controllers) {
      controller.clear();
    }
    
    // Focus first field
    _focusNodes[0].requestFocus();
    
    ToastMessage().showToast("OTP resent to +91 ${widget.mobileNumber}");
  }

  void _changePhoneNumber() {
    HapticFeedback.selectionClick();
    String route = widget.firstName != null 
        ? Routes.demoScreen
        : Routes.loginWithOtpScreen;
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlueDark,
              AppColors.primaryBlueLight,
              AppColors.secondaryTeal,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AnimatedLogo(
    size: 140,
    padding: EdgeInsets.all(8),
  ),
                  const SizedBox(height: 60),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildOtpInputFields(),
                  const SizedBox(height: 40),
                  _buildResendSection(),
                  const SizedBox(height: 30),
                  _buildChangeNumberButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Verify Your Number",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          // TextStyle(
          //   fontSize: 28,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.white,
          //   shadows: [
          //     Shadow(
          //       offset: const Offset(0, 2),
          //       blurRadius: 8,
          //       color: Colors.black.withOpacity(0.3),
          //     ),
          //   ],
          // ),
        ),
        const SizedBox(height: 20),
        Text(
          "We've sent a 6-digit verification code to",
          style: TextTheme.of(context).bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
          //  TextStyle(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          //   color: Colors.white.withOpacity(0.9),
          //   height: 1.4,
          // ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Text(
            "+91 ${widget.mobileNumber}",
            style: TextTheme.of(context).bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ), 
            // TextStyle(
            //   fontSize: 18,
            //   fontWeight: FontWeight.w600,
            //   color: Colors.white,
            //   letterSpacing: 1.2,
            // ),
          ),
        ),
      ],
    );
  }
  Widget _buildOtpInputFields() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * 10 * (1 - _shakeAnimation.value), 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => _buildOtpField(index)),
                ),
                if (_isVerifying) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpField(int index) {
    bool hasValue = _controllers[index].text.isNotEmpty;
    bool hasFocus = _focusNodes[index].hasFocus;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: hasValue ? Colors.white : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFocus 
              ? AppColors.primaryBlueDark
              : hasValue 
                  ? Colors.green.shade400
                  : Colors.grey.shade300,
          width: hasFocus ? 2 : 1.5,
        ),
        boxShadow: [
          if (hasFocus || hasValue)
            BoxShadow(
              color: (hasFocus ? AppColors.primaryBlue : Colors.green.shade400)
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextTheme.of(context).headlineSmall?.copyWith(
          color: hasValue ? Colors.green.shade700 : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        // TextStyle(
        //   fontSize: 24,
        //   fontWeight: FontWeight.bold,
        //   color: hasValue ? Colors.green.shade700 : Colors.black87,
        // ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _onTextChanged(index, value),
        onSubmitted: (_) => _onTextChanged(index, _controllers[index].text),
      ),
    );
  }
  Widget _buildResendSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _canResend
          ? _buildResendButton()
          : _buildCountdownText(),
    );
  }

  Widget _buildResendButton() {
    return Container(
      key: const ValueKey('resend'),
      child: TextButton.icon(
        onPressed: _resendOtp,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          "Didn't receive the code? Resend",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          // TextStyle(
          //   color: Colors.white,
          //   fontWeight: FontWeight.w600,
          //   fontSize: 16,
          // ),
        ),
      ),
    );
  }

  Widget _buildCountdownText() {
    return Container(
      key: const ValueKey('countdown'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "Resend code in $_secondsRemaining seconds",
            style: TextTheme.of(context).bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            // TextStyle(
            //   color: Colors.white.withOpacity(0.9),
            //   fontWeight: FontWeight.w500,
            //   fontSize: 16,
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeNumberButton() {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _changePhoneNumber,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 20,
        ),
        label:  Text(
          "Change phone number",
          style: TextTheme.of(context).bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          // TextStyle(
          //   color: Colors.white,
          //   fontSize: 16,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
      ),
    );
  }
}