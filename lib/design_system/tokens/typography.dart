import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale using Google Fonts Nunito
abstract class AppTypography {

  // ============ Display Styles ============
  /// Display Large - Hero text, splash screens
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  /// Display Medium - Large headings
  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      );

  /// Display Small - Prominent headings
  static TextStyle get displaySmall => GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  // ============ Headline Styles ============
  /// Headline Large - Page titles
  static TextStyle get headlineLarge => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.25,
      );

  /// Headline Medium - Section headers
  static TextStyle get headlineMedium => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      );

  /// Headline Small - Sub-section headers
  static TextStyle get headlineSmall => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      );

  // ============ Title Styles ============
  /// Title Large - Card titles, dialogs
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      );

  /// Title Medium - List item titles
  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      );

  /// Title Small - Smaller titles
  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ============ Body Styles ============
  /// Body Large - Primary content
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  /// Body Medium - Secondary content
  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  /// Body Small - Tertiary content, captions
  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ============ Label Styles ============
  /// Label Large - Buttons, prominent labels
  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// Label Medium - Form labels, chips
  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      );

  /// Label Small - Smallest labels
  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // ============ Special Styles ============
  /// Alarm time display
  static TextStyle get alarmTime => GoogleFonts.nunito(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.0,
      );

  /// Statistics number display
  static TextStyle get statNumber => GoogleFonts.nunito(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.1,
      );

  /// Stat label
  static TextStyle get statLabel => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        height: 1.4,
      );

  /// Time remaining badge
  static TextStyle get timeBadge => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        height: 1.2,
      );

  /// Create a complete TextTheme for ThemeData
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
