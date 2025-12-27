import 'package:flutter/material.dart';

/// Shadow/Elevation tokens
abstract class AppShadows {
  /// No shadow
  static const List<BoxShadow> none = [];

  /// Extra small shadow - Subtle elevation
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow - Cards, buttons
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow - Dropdowns, popovers
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow - Modals, dialogs
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  /// Extra large shadow - Navigation drawers
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 6),
    ),
  ];

  /// XXL shadow - Floating elements
  static const List<BoxShadow> xxl = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
  ];

  // ============ Colored Shadows ============

  /// Primary color shadow for buttons
  static List<BoxShadow> primaryShadow(Color primaryColor) => [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Success color shadow
  static List<BoxShadow> successShadow(Color successColor) => [
        BoxShadow(
          color: successColor.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Error color shadow
  static List<BoxShadow> errorShadow(Color errorColor) => [
        BoxShadow(
          color: errorColor.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ============ Dark Mode Shadows ============

  /// Small shadow for dark mode
  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow for dark mode
  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow for dark mode
  static const List<BoxShadow> lgDark = [
    BoxShadow(
      color: Color(0x59000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ============ Inset Shadows ============

  /// Inner shadow for pressed states
  static const List<BoxShadow> innerSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Inner shadow for inputs
  static const List<BoxShadow> innerMd = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];
}

/// Material elevation values
abstract class AppElevation {
  /// No elevation
  static const double none = 0;

  /// Level 1 - Cards, search bars
  static const double level1 = 1;

  /// Level 2 - Buttons, chips
  static const double level2 = 3;

  /// Level 3 - FAB resting, nav rail
  static const double level3 = 6;

  /// Level 4 - FAB pressed
  static const double level4 = 8;

  /// Level 5 - Navigation drawer, modal
  static const double level5 = 12;
}
