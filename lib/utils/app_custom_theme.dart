import 'package:flutter/material.dart';
import 'app_sizes.dart';
// Assumes you have defined sizes like AppSizes.xs, radiusMd, etc.

/// Custom theme extension for additional design system properties
/// Accessible via Theme.of(context).extension<AppCustomTheme>()
@immutable
class AppCustomTheme extends ThemeExtension<AppCustomTheme> {
  const AppCustomTheme({
    required this.spacing,
    required this.borderRadius,
    required this.shadows,
    required this.gradients,
    required this.customColors,
  });

  final AppSpacing spacing;
  final AppBorderRadius borderRadius;
  final AppShadows shadows;
  final AppGradients gradients;
  final AppCustomColors customColors;

  /// Light theme extension
  static const AppCustomTheme light = AppCustomTheme(
    spacing: AppSpacing(),
    borderRadius: AppBorderRadius(),
    shadows: AppShadows.light,
    gradients: AppGradients.light,
    customColors: AppCustomColors.light,
  );

  /// Dark theme extension
  static const AppCustomTheme dark = AppCustomTheme(
    spacing: AppSpacing(),
    borderRadius: AppBorderRadius(),
    shadows: AppShadows.dark,
    gradients: AppGradients.dark,
    customColors: AppCustomColors.dark,
  );

  @override
  AppCustomTheme copyWith({
    AppSpacing? spacing,
    AppBorderRadius? borderRadius,
    AppShadows? shadows,
    AppGradients? gradients,
    AppCustomColors? customColors,
  }) {
    return AppCustomTheme(
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      gradients: gradients ?? this.gradients,
      customColors: customColors ?? this.customColors,
    );
  }

  @override
  AppCustomTheme lerp(ThemeExtension<AppCustomTheme>? other, double t) {
    if (other is! AppCustomTheme) return this;
    return AppCustomTheme(
      spacing: spacing,
      borderRadius: borderRadius,
      shadows: AppShadows.lerp(shadows, other.shadows, t),
      gradients: AppGradients.lerp(gradients, other.gradients, t),
      customColors: AppCustomColors.lerp(customColors, other.customColors, t),
    );
  }
}

/// Custom spacing values
@immutable
class AppSpacing {
  const AppSpacing();

  double get xs => AppSizes.xs;
  double get sm => AppSizes.sm;
  double get md => AppSizes.md;
  double get lg => AppSizes.lg;
  double get xl => AppSizes.xl;
  double get xxl => AppSizes.xxl;
  double get xxxl => AppSizes.xxxl;
}

/// Custom border radius values
@immutable
class AppBorderRadius {
  const AppBorderRadius();

  double get xs => AppSizes.radiusXs;
  double get sm => AppSizes.radiusSm;
  double get md => AppSizes.radiusMd;
  double get lg => AppSizes.radiusLg;
  double get xl => AppSizes.radiusXl;
  double get full => AppSizes.radiusFull;
}

/// Custom shadows
@immutable
class AppShadows {
  const AppShadows({
    required this.small,
    required this.medium,
    required this.large,
  });

  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;

  static const AppShadows light = AppShadows(
    small: [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
    medium: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 8.0,
        offset: Offset(0, 4),
      ),
    ],
    large: [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 16.0,
        offset: Offset(0, 8),
      ),
    ],
  );

  static const AppShadows dark = AppShadows(
    small: [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
    medium: [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 8.0,
        offset: Offset(0, 4),
      ),
    ],
    large: [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 16.0,
        offset: Offset(0, 8),
      ),
    ],
  );

  static AppShadows lerp(AppShadows a, AppShadows b, double t) {
    return AppShadows(
      small: BoxShadow.lerpList(a.small, b.small, t) ?? a.small,
      medium: BoxShadow.lerpList(a.medium, b.medium, t) ?? a.medium,
      large: BoxShadow.lerpList(a.large, b.large, t) ?? a.large,
    );
  }
}

/// Custom gradients
@immutable
class AppGradients {
  const AppGradients({
    required this.primary,
    required this.background,
  });

  final Gradient primary;
  final Gradient background;

  static const AppGradients light = AppGradients(
    primary: LinearGradient(
      colors: [Color(0xFF6D9EFF), Color(0xFF8AABFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    background: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static const AppGradients dark = AppGradients(
    primary: LinearGradient(
      colors: [Color(0xFF1F3C88), Color(0xFF274690)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    background: LinearGradient(
      colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static AppGradients lerp(AppGradients a, AppGradients b, double t) {
    return AppGradients(
      primary: LinearGradient(
        colors: List.generate(
          a.primary.colors.length,
          (i) => Color.lerp(a.primary.colors[i], b.primary.colors[i], t)!,
        ),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      background: LinearGradient(
        colors: List.generate(
          a.background.colors.length,
          (i) => Color.lerp(a.background.colors[i], b.background.colors[i], t)!,
        ),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

/// Custom semantic colors
@immutable
class AppCustomColors {
  const AppCustomColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  static const AppCustomColors light = AppCustomColors(
    success: Color(0xFF28A745),
    warning: Color(0xFFFFC107),
    error: Color(0xFFDC3545),
    info: Color(0xFF17A2B8),
  );

  static const AppCustomColors dark = AppCustomColors(
    success: Color(0xFF28D07A),
    warning: Color(0xFFFFD54F),
    error: Color(0xFFEF5350),
    info: Color(0xFF29B6F6),
  );

  static AppCustomColors lerp(AppCustomColors a, AppCustomColors b, double t) {
    return AppCustomColors(
      success: Color.lerp(a.success, b.success, t)!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      info: Color.lerp(a.info, b.info, t)!,
    );
  }
}
