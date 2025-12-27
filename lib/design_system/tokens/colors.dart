import 'package:flutter/material.dart';

/// Seed color for Material 3 color scheme generation
const Color seedColor = Color(0xFF6366F1); // Indigo

/// Light theme semantic colors
abstract class AppColorsLight {
  // Primary colors
  static const Color primary = Color(0xFF5B5FC7);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE1E0FF);
  static const Color onPrimaryContainer = Color(0xFF17005E);

  // Secondary colors
  static const Color secondary = Color(0xFF5E5C71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE4DFF9);
  static const Color onSecondaryContainer = Color(0xFF1B192C);

  // Tertiary colors
  static const Color tertiary = Color(0xFF7A5367);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E6);
  static const Color onTertiaryContainer = Color(0xFF2E1123);

  // Surface colors
  static const Color surface = Color(0xFFFCFCFF);
  static const Color onSurface = Color(0xFF1B1B1F);
  static const Color surfaceVariant = Color(0xFFE4E1EC);
  static const Color onSurfaceVariant = Color(0xFF46464F);
  static const Color surfaceContainer = Color(0xFFF3F0F4);
  static const Color surfaceContainerHigh = Color(0xFFEDEAEF);
  static const Color surfaceContainerHighest = Color(0xFFE7E5E9);

  // Outline colors
  static const Color outline = Color(0xFF777680);
  static const Color outlineVariant = Color(0xFFC8C5D0);

  // Background
  static const Color background = Color(0xFFFCFCFF);
  static const Color onBackground = Color(0xFF1B1B1F);

  // Inverse colors
  static const Color inverseSurface = Color(0xFF303034);
  static const Color onInverseSurface = Color(0xFFF3F0F4);
  static const Color inversePrimary = Color(0xFFC1C1FF);
}

/// Dark theme semantic colors
abstract class AppColorsDark {
  // Primary colors
  static const Color primary = Color(0xFFC1C1FF);
  static const Color onPrimary = Color(0xFF2A2893);
  static const Color primaryContainer = Color(0xFF4345AD);
  static const Color onPrimaryContainer = Color(0xFFE1E0FF);

  // Secondary colors
  static const Color secondary = Color(0xFFC8C3DC);
  static const Color onSecondary = Color(0xFF302E42);
  static const Color secondaryContainer = Color(0xFF464459);
  static const Color onSecondaryContainer = Color(0xFFE4DFF9);

  // Tertiary colors
  static const Color tertiary = Color(0xFFEBB8CD);
  static const Color onTertiary = Color(0xFF462638);
  static const Color tertiaryContainer = Color(0xFF5F3C4F);
  static const Color onTertiaryContainer = Color(0xFFFFD8E6);

  // Surface colors
  static const Color surface = Color(0xFF131316);
  static const Color onSurface = Color(0xFFE5E1E9);
  static const Color surfaceVariant = Color(0xFF46464F);
  static const Color onSurfaceVariant = Color(0xFFC8C5D0);
  static const Color surfaceContainer = Color(0xFF1F1F23);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2E);
  static const Color surfaceContainerHighest = Color(0xFF353539);

  // Outline colors
  static const Color outline = Color(0xFF918F9A);
  static const Color outlineVariant = Color(0xFF46464F);

  // Background
  static const Color background = Color(0xFF131316);
  static const Color onBackground = Color(0xFFE5E1E9);

  // Inverse colors
  static const Color inverseSurface = Color(0xFFE5E1E9);
  static const Color onInverseSurface = Color(0xFF303034);
  static const Color inversePrimary = Color(0xFF5B5FC7);
}

/// Semantic colors (same for both themes)
abstract class AppSemanticColors {
  // Success
  static const Color success = Color(0xFF10B981);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF064E3B);

  // Error
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color onWarning = Color(0xFF000000);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF78350F);

  // Info
  static const Color info = Color(0xFF3B82F6);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFDBEAFE);
  static const Color onInfoContainer = Color(0xFF1E3A8A);
}

/// Priority colors
abstract class PriorityColors {
  static const Color high = Color(0xFFEF4444);
  static const Color highContainer = Color(0xFFFEE2E2);
  static const Color medium = Color(0xFFF59E0B);
  static const Color mediumContainer = Color(0xFFFEF3C7);
  static const Color low = Color(0xFF10B981);
  static const Color lowContainer = Color(0xFFD1FAE5);
}

/// Category default colors
abstract class CategoryColors {
  static const Color work = Color(0xFF6366F1);
  static const Color personal = Color(0xFF8B5CF6);
  static const Color health = Color(0xFF10B981);
  static const Color finance = Color(0xFFF59E0B);
  static const Color shopping = Color(0xFFEF4444);
  static const Color education = Color(0xFF3B82F6);
  static const Color travel = Color(0xFF06B6D4);
  static const Color home = Color(0xFFEC4899);
}
