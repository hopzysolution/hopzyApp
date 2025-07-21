
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_sizes.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/app_typography.dart';

class AppWidgetThemes {
  AppWidgetThemes._();

  /// Elevated button theme
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        elevation: 2.0,
        shadowColor: Colors.black.withOpacity(0.1),
        textStyle: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: AppTypography.medium,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Text button theme
  static TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: AppTypography.medium,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Outlined button theme
  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        side: const BorderSide(width: 1.5),
        textStyle: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: AppTypography.medium,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Input decoration theme
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(AppSizes.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(color: AppColors.neutral300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(color: AppColors.neutral300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(color: AppColors.error, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: AppTypography.regular,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: AppTypography.regular,
        color: AppColors.neutral500,
      ),
    );
  }

  /// Light app bar theme
  static AppBarTheme get lightAppBarTheme {
    return AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.neutral900,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18.0,
        fontWeight: AppTypography.semiBold,
        color: AppColors.neutral900,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neutral900,
        size: AppSizes.iconMd,
      ),
      systemOverlayStyle: AppTheme.lightSystemUiOverlayStyle,
    );
  }

  /// Dark app bar theme
  static AppBarTheme get darkAppBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.darkColorScheme.surface,
      foregroundColor: AppColors.darkColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18.0,
        fontWeight: AppTypography.semiBold,
        color: AppColors.darkColorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: AppColors.darkColorScheme.onSurface,
        size: AppSizes.iconMd,
      ),
      systemOverlayStyle: AppTheme.darkSystemUiOverlayStyle,
    );
  }

  /// Card theme
  static CardThemeData get cardTheme {
    return CardThemeData(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      margin: const EdgeInsets.all(AppSizes.sm),
    );
  }

  /// Chip theme
  static ChipThemeData get chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.neutral100,
      deleteIconColor: AppColors.neutral600,
      disabledColor: AppColors.neutral200,
      selectedColor: AppColors.primaryBlue.withOpacity(0.1),
      secondarySelectedColor: AppColors.secondaryTeal.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: AppTypography.medium,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: AppTypography.medium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
    );
  }

  /// Divider theme
  static DividerThemeData get dividerTheme {
    return const DividerThemeData(
      color: AppColors.neutral200,
      thickness: 1.0,
      space: 1.0,
    );
  }

  /// Floating action button theme
  static FloatingActionButtonThemeData get floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
    );
  }

  /// Bottom navigation bar theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.neutral500,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12.0,
        fontWeight: AppTypography.medium,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12.0,
        fontWeight: AppTypography.regular,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    );
  }

  /// Tab bar theme
  static TabBarThemeData get tabBarTheme {
    return TabBarThemeData(
      labelColor: AppColors.primaryBlue,
      unselectedLabelColor: AppColors.neutral500,
      labelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: AppTypography.medium,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: AppTypography.regular,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2.0,
        ),
      ),
    );
  }

  /// Dialog theme
  static DialogThemeData get dialogTheme {
    return DialogThemeData(
      backgroundColor: Colors.white,
      elevation: AppSizes.modalElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: AppTypography.semiBold,
        color: AppColors.neutral900,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: AppTypography.regular,
        color: AppColors.neutral700,
      ),
    );
  }

  /// Snackbar theme
  static SnackBarThemeData get snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppColors.neutral800,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: AppTypography.regular,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4.0,
    );
  }
}
