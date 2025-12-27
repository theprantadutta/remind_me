import 'package:flutter/material.dart';
import '../tokens/colors.dart';

/// Light color scheme using Material 3
ColorScheme get lightColorScheme => ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ).copyWith(
      // Override with our custom colors if needed
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.onPrimary,
      primaryContainer: AppColorsLight.primaryContainer,
      onPrimaryContainer: AppColorsLight.onPrimaryContainer,
      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.onSecondary,
      secondaryContainer: AppColorsLight.secondaryContainer,
      onSecondaryContainer: AppColorsLight.onSecondaryContainer,
      tertiary: AppColorsLight.tertiary,
      onTertiary: AppColorsLight.onTertiary,
      tertiaryContainer: AppColorsLight.tertiaryContainer,
      onTertiaryContainer: AppColorsLight.onTertiaryContainer,
      error: AppSemanticColors.error,
      onError: AppSemanticColors.onError,
      errorContainer: AppSemanticColors.errorContainer,
      onErrorContainer: AppSemanticColors.onErrorContainer,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.onSurface,
      surfaceContainerHighest: AppColorsLight.surfaceContainerHighest,
      outline: AppColorsLight.outline,
      outlineVariant: AppColorsLight.outlineVariant,
      inverseSurface: AppColorsLight.inverseSurface,
      onInverseSurface: AppColorsLight.onInverseSurface,
      inversePrimary: AppColorsLight.inversePrimary,
    );

/// Dark color scheme using Material 3
ColorScheme get darkColorScheme => ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ).copyWith(
      // Override with our custom colors if needed
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      primaryContainer: AppColorsDark.primaryContainer,
      onPrimaryContainer: AppColorsDark.onPrimaryContainer,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      secondaryContainer: AppColorsDark.secondaryContainer,
      onSecondaryContainer: AppColorsDark.onSecondaryContainer,
      tertiary: AppColorsDark.tertiary,
      onTertiary: AppColorsDark.onTertiary,
      tertiaryContainer: AppColorsDark.tertiaryContainer,
      onTertiaryContainer: AppColorsDark.onTertiaryContainer,
      error: AppSemanticColors.error,
      onError: AppSemanticColors.onError,
      errorContainer: AppSemanticColors.errorContainer,
      onErrorContainer: AppSemanticColors.onErrorContainer,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      surfaceContainerHighest: AppColorsDark.surfaceContainerHighest,
      outline: AppColorsDark.outline,
      outlineVariant: AppColorsDark.outlineVariant,
      inverseSurface: AppColorsDark.inverseSurface,
      onInverseSurface: AppColorsDark.onInverseSurface,
      inversePrimary: AppColorsDark.inversePrimary,
    );
