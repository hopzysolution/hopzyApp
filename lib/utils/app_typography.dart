import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static String get fontFamily => GoogleFonts.inter().fontFamily!;
  /// Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// Centralized TextTheme using different fonts
  static TextTheme get textTheme {
    return TextTheme(
      // Hero Headlines - Playfair Display
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: bold,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: bold,
        letterSpacing: 0.0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: bold,
        letterSpacing: 0.0,
        height: 1.22,
      ),

      // Headline - Testimonials/Quotes - Lora
      headlineLarge: GoogleFonts.lora(
        fontSize: 32,
        fontWeight: regular,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: regular,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: regular,
        height: 1.33,
      ),

      // Titles - Poppins (Navigation/Buttons)
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: semiBold,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body - Urbanist (neutral readable)
      bodyLarge: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Labels/Pricing - Archivo
      labelLarge: GoogleFonts.archivo(
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.archivo(
        fontSize: 12,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.archivo(
        fontSize: 11,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Responsive font size (optional helper)
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0; // Base iPhone 8 width
    return baseSize * scaleFactor.clamp(0.8, 1.2);
  }
}
