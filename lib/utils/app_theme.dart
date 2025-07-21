
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_custom_theme.dart';
import 'package:ridebooking/utils/app_typography.dart' show AppTypography;
import 'package:ridebooking/utils/app_widget_theme.dart';

/// Main theme class that provides centralized theming for the entire app
/// Supports light/dark modes, custom extensions, and follows Material Design 3
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Returns the light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.lightColorScheme,
      textTheme: AppTypography.textTheme,
      elevatedButtonTheme: AppWidgetThemes.elevatedButtonTheme,
      textButtonTheme: AppWidgetThemes.textButtonTheme,
      outlinedButtonTheme: AppWidgetThemes.outlinedButtonTheme,
      inputDecorationTheme: AppWidgetThemes.inputDecorationTheme,
      appBarTheme: AppWidgetThemes.lightAppBarTheme,
      cardTheme: AppWidgetThemes.cardTheme,
      chipTheme: AppWidgetThemes.chipTheme,
      dividerTheme: AppWidgetThemes.dividerTheme,
      floatingActionButtonTheme: AppWidgetThemes.floatingActionButtonTheme,
      bottomNavigationBarTheme: AppWidgetThemes.bottomNavigationBarTheme,
      tabBarTheme: AppWidgetThemes.tabBarTheme,
      dialogTheme: AppWidgetThemes.dialogTheme,
      snackBarTheme: AppWidgetThemes.snackBarTheme,
      extensions: <ThemeExtension<dynamic>>[
        AppCustomTheme.light,
      ],
    );
  }

  /// Returns the dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.darkColorScheme,
      textTheme: AppTypography.textTheme,
      elevatedButtonTheme: AppWidgetThemes.elevatedButtonTheme,
      textButtonTheme: AppWidgetThemes.textButtonTheme,
      outlinedButtonTheme: AppWidgetThemes.outlinedButtonTheme,
      inputDecorationTheme: AppWidgetThemes.inputDecorationTheme,
      appBarTheme: AppWidgetThemes.darkAppBarTheme,
      cardTheme: AppWidgetThemes.cardTheme,
      chipTheme: AppWidgetThemes.chipTheme,
      dividerTheme: AppWidgetThemes.dividerTheme,
      floatingActionButtonTheme: AppWidgetThemes.floatingActionButtonTheme,
      bottomNavigationBarTheme: AppWidgetThemes.bottomNavigationBarTheme,
      tabBarTheme: AppWidgetThemes.tabBarTheme,
      dialogTheme: AppWidgetThemes.dialogTheme,
      snackBarTheme: AppWidgetThemes.snackBarTheme,
      extensions: <ThemeExtension<dynamic>>[
        AppCustomTheme.dark,
      ],
    );
  }

  /// System UI overlay style for light theme
  static SystemUiOverlayStyle get lightSystemUiOverlayStyle {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.lightColorScheme.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  /// System UI overlay style for dark theme
  static SystemUiOverlayStyle get darkSystemUiOverlayStyle {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.darkColorScheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }
}
