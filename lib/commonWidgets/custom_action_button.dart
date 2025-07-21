import 'package:flutter/material.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_sizes.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double fontSize;
  final IconData? icon;
  final bool isLoading;
  final double iconSize;
  final double borderRadius;
  final double elevation;
  final Color textColor;

  const CustomActionButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.height = 48.0,
    this.width = double.infinity,
    this.backgroundColor = AppColors.primaryBlue,
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.fontSize = 14.0,
    this.icon,
    this.isLoading = false,
    this.iconSize = 18.0,
    this.borderRadius = 16.0,
    this.elevation = 0.0,
    this.textColor = AppColors.neutral100,
  }) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              width: 2,
              color: borderColor),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
