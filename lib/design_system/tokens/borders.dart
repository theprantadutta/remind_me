import 'package:flutter/material.dart';

/// Border radius tokens
abstract class AppBorderRadius {
  /// 4px - Extra small, chips
  static const double xs = 4.0;

  /// 8px - Small, buttons
  static const double sm = 8.0;

  /// 12px - Medium, cards
  static const double md = 12.0;

  /// 16px - Large, modals
  static const double lg = 16.0;

  /// 20px - Extra large, cards
  static const double xl = 20.0;

  /// 24px - XXL, bottom sheets
  static const double xxl = 24.0;

  /// 28px - XXXL, special containers
  static const double xxxl = 28.0;

  /// 9999px - Full, pills
  static const double full = 9999.0;

  // Pre-built BorderRadius objects
  static BorderRadius get radiusXs => BorderRadius.circular(xs);
  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusXxl => BorderRadius.circular(xxl);
  static BorderRadius get radiusXxxl => BorderRadius.circular(xxxl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);

  // Top-only radius for bottom sheets
  static BorderRadius get topXl => const BorderRadius.vertical(
        top: Radius.circular(xl),
      );

  static BorderRadius get topXxl => const BorderRadius.vertical(
        top: Radius.circular(xxl),
      );
}

/// Border width tokens
abstract class AppBorderWidth {
  /// 0.5px - Hairline border
  static const double hairline = 0.5;

  /// 1px - Default border
  static const double thin = 1.0;

  /// 1.5px - Medium border
  static const double medium = 1.5;

  /// 2px - Thick border
  static const double thick = 2.0;

  /// 3px - Extra thick border
  static const double extraThick = 3.0;
}

/// Pre-built InputBorder for form fields
abstract class AppInputBorders {
  static OutlineInputBorder outline({
    Color? color,
    double width = AppBorderWidth.thin,
    double radius = AppBorderRadius.md,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color ?? Colors.grey.shade300,
        width: width,
      ),
    );
  }

  static OutlineInputBorder outlineNone({
    double radius = AppBorderRadius.md,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    );
  }

  static UnderlineInputBorder underline({
    Color? color,
    double width = AppBorderWidth.thin,
  }) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color ?? Colors.grey.shade300,
        width: width,
      ),
    );
  }
}

/// Shape tokens for Material components
abstract class AppShapes {
  static RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
        borderRadius: AppBorderRadius.radiusXl,
      );

  static RoundedRectangleBorder get buttonShape => RoundedRectangleBorder(
        borderRadius: AppBorderRadius.radiusMd,
      );

  static RoundedRectangleBorder get dialogShape => RoundedRectangleBorder(
        borderRadius: AppBorderRadius.radiusXxl,
      );

  static RoundedRectangleBorder get bottomSheetShape =>
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.xxl),
        ),
      );

  static RoundedRectangleBorder get chipShape => RoundedRectangleBorder(
        borderRadius: AppBorderRadius.radiusSm,
      );

  static StadiumBorder get pillShape => const StadiumBorder();
}
