import 'package:flutter/material.dart';

/// Spacing scale based on 4px base unit
abstract class AppSpacing {
  /// 4px - Extra small, tight spacing
  static const double xs = 4.0;

  /// 8px - Small gaps
  static const double sm = 8.0;

  /// 12px - Medium gaps
  static const double md = 12.0;

  /// 16px - Default/base spacing
  static const double base = 16.0;

  /// 20px - Slightly larger than base
  static const double lg = 20.0;

  /// 24px - Section gaps
  static const double xl = 24.0;

  /// 32px - Large sections
  static const double xxl = 32.0;

  /// 48px - Page-level spacing
  static const double xxxl = 48.0;

  /// 64px - Extra large spacing
  static const double huge = 64.0;
}

/// Semantic spacing values
abstract class AppSemanticSpacing {
  /// Padding inside cards
  static const double cardPadding = AppSpacing.base;

  /// Space between list items
  static const double listItemSpacing = AppSpacing.md;

  /// Space between sections
  static const double sectionSpacing = AppSpacing.xl;

  /// Horizontal padding for screens
  static const double screenPadding = AppSpacing.base;

  /// Vertical padding for input fields
  static const double inputVerticalPadding = 14.0;

  /// Horizontal padding for input fields
  static const double inputHorizontalPadding = AppSpacing.base;

  /// Space between form fields
  static const double formFieldSpacing = AppSpacing.base;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 80.0;

  /// App bar height
  static const double appBarHeight = 56.0;

  /// FAB offset from bottom
  static const double fabBottomOffset = 16.0;
}

/// Pre-defined EdgeInsets for common use cases
abstract class AppEdgeInsets {
  /// Screen horizontal padding
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: AppSpacing.base,
  );

  /// Screen all-around padding
  static const EdgeInsets screen = EdgeInsets.all(AppSpacing.base);

  /// Card internal padding
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.base);

  /// Card with more padding
  static const EdgeInsets cardLarge = EdgeInsets.all(AppSpacing.lg);

  /// List item padding
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: AppSpacing.base,
    vertical: AppSpacing.md,
  );

  /// Input field internal padding
  static const EdgeInsets input = EdgeInsets.symmetric(
    horizontal: AppSpacing.base,
    vertical: 14.0,
  );

  /// Section padding (bottom only)
  static const EdgeInsets sectionBottom = EdgeInsets.only(
    bottom: AppSpacing.xl,
  );

  /// Chip padding
  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.xs,
  );

  /// Button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.md,
  );

  /// Dialog padding
  static const EdgeInsets dialog = EdgeInsets.all(AppSpacing.xl);

  /// Bottom sheet padding
  static const EdgeInsets bottomSheet = EdgeInsets.fromLTRB(
    AppSpacing.base,
    AppSpacing.sm,
    AppSpacing.base,
    AppSpacing.xl,
  );

  /// No padding
  static const EdgeInsets zero = EdgeInsets.zero;
}

/// Gap widgets for SizedBox spacing
abstract class AppGaps {
  /// Horizontal gaps
  static const SizedBox hXs = SizedBox(width: AppSpacing.xs);
  static const SizedBox hSm = SizedBox(width: AppSpacing.sm);
  static const SizedBox hMd = SizedBox(width: AppSpacing.md);
  static const SizedBox hBase = SizedBox(width: AppSpacing.base);
  static const SizedBox hLg = SizedBox(width: AppSpacing.lg);
  static const SizedBox hXl = SizedBox(width: AppSpacing.xl);
  static const SizedBox hXxl = SizedBox(width: AppSpacing.xxl);

  /// Vertical gaps
  static const SizedBox vXs = SizedBox(height: AppSpacing.xs);
  static const SizedBox vSm = SizedBox(height: AppSpacing.sm);
  static const SizedBox vMd = SizedBox(height: AppSpacing.md);
  static const SizedBox vBase = SizedBox(height: AppSpacing.base);
  static const SizedBox vLg = SizedBox(height: AppSpacing.lg);
  static const SizedBox vXl = SizedBox(height: AppSpacing.xl);
  static const SizedBox vXxl = SizedBox(height: AppSpacing.xxl);
  static const SizedBox vXxxl = SizedBox(height: AppSpacing.xxxl);
}
