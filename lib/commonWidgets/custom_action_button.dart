import 'package:flutter/material.dart';
import 'package:ridebooking/utils/app_colors.dart';

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
    this.borderRadius = 12.0,
    this.elevation = 0.0,
    this.textColor = AppColors.neutral100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: foregroundColor.withOpacity(0.2),
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: isDisabled ? backgroundColor.withOpacity(0.6) : backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(
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
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: iconSize, color: textColor),
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
        ),
      ),
    );
  }
}
