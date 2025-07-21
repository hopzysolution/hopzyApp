/// Centralized color management with Material Design 3 color system
/// Uses semantic color roles that adapt to light/dark themes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  // Primary blue color palette
  static const Color primaryBlue = Color(0xFF2563EB); // Blue-600
  static const Color primaryBlueLight = Color(0xFF3B82F6); // Blue-500
  static const Color primaryBlueDark = Color(0xFF1D4ED8); // Blue-700
  static const Color primaryBlueAccent = Color.fromARGB(255, 160, 200, 249); // Blue-400

  // Secondary colors
  static const Color secondaryTeal = Color(0xFF06B6D4); // Cyan-500
  static const Color secondaryPurple = Color(0xFF8B5CF6); // Violet-500

  // Neutral colors
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);

  // Semantic colors
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  /// Light theme color scheme following Material Design 3
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryBlue,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDCECFF),
    onPrimaryContainer: Color(0xFF001D35),
    secondary: secondaryTeal,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFB3F0FF),
    onSecondaryContainer: Color(0xFF001F24),
    tertiary: secondaryPurple,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE9DDFF),
    onTertiaryContainer: Color(0xFF1F0054),
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Colors.white,
    onBackground: neutral900,
    surface: Colors.white,
    onSurface: neutral900,
    surfaceVariant: neutral100,
    onSurfaceVariant: neutral700,
    outline: neutral400,
    outlineVariant: neutral200,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: neutral800,
    onInverseSurface: neutral100,
    inversePrimary: Color(0xFF9FCAFF),
    surfaceTint: primaryBlue,
  );

  /// Dark theme color scheme following Material Design 3
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9FCAFF),
    onPrimary: Color(0xFF003257),
    primaryContainer: Color(0xFF00497A),
    onPrimaryContainer: Color(0xFFDCECFF),
    secondary: Color(0xFF54D6F5),
    onSecondary: Color(0xFF003640),
    secondaryContainer: Color(0xFF004E5D),
    onSecondaryContainer: Color(0xFFB3F0FF),
    tertiary: Color(0xFFCFBCFF),
    onTertiary: Color(0xFF35006A),
    tertiaryContainer: Color(0xFF4F2C91),
    onTertiaryContainer: Color(0xFFE9DDFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF101318),
    onBackground: Color(0xFFE0E2E8),
    surface: Color(0xFF101318),
    onSurface: Color(0xFFE0E2E8),
    surfaceVariant: Color(0xFF40484C),
    onSurfaceVariant: Color(0xFFC0C8CD),
    outline: Color(0xFF8A9297),
    outlineVariant: Color(0xFF40484C),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE0E2E8),
    onInverseSurface: Color(0xFF2E3135),
    inversePrimary: primaryBlue,
    surfaceTint: Color(0xFF9FCAFF),
  );
}
