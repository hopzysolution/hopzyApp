import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridebooking/utils/app_colors.dart'; // Adjust the path if needed

class EmailField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTablet;
  final bool isSmallScreen;
  final bool isFormValid;
  final void Function()? onSubmit;
  final void Function()? onTap;

  const EmailField({
    super.key,
    required this.context,
    required this.controller,
    required this.focusNode,
    required this.isTablet,
    required this.isSmallScreen,
    required this.isFormValid,
    this.onSubmit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = isTablet ? 16.0 : (isSmallScreen ? 14.0 : 15.0);
    final iconSize = isTablet ? 24.0 : (isSmallScreen ? 18.0 : 20.0);
    final verticalPadding = isTablet ? 20.0 : (isSmallScreen ? 14.0 : 16.0);
    final hasFocus = focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: hasFocus
                ? AppColors.primaryBlue.withOpacity(0.2)
                : Colors.black.withOpacity(0.08),
            blurRadius: hasFocus ? 20 : 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')), // prevent spaces
        ],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          hintText: 'Email Address',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 18 : (isSmallScreen ? 12 : 14),
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.1),
                  AppColors.secondaryTeal.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              border: Border(
                right: BorderSide(
                  color: hasFocus
                      ? AppColors.primaryBlue.withOpacity(0.3)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
            child: Icon(
              Icons.email_outlined,
              color: hasFocus ? AppColors.primaryBlue : Colors.grey.shade500,
              size: iconSize,
            ),
          ),
          suffixIcon: hasValue
              ? Container(
                  padding: EdgeInsets.all(
                    isTablet ? 16 : (isSmallScreen ? 10 : 12),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isFormValid ? Icons.check_circle : Icons.error_outline,
                      color: isFormValid
                          ? Colors.green.shade500
                          : Colors.orange.shade400,
                      size: iconSize,
                      key: ValueKey(isFormValid),
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange.shade400, width: 2.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: isTablet ? 24 : (isSmallScreen ? 14 : 18),
          ),
        ),
        validator: (value) {
  if (value == null || value.trim().isEmpty) {
  return 'Email is required';
} else if (value.trim().length > 30) {
  return 'Email must be under 30 characters';
} else if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.(com)$").hasMatch(value.trim())) {
  return 'Email must be valid and end with .com';
}
return null;

},

        onFieldSubmitted: (_) => onSubmit?.call(),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
      ),
    );
  }
}
