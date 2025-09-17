
import 'package:flutter/material.dart';

// Primary colors
const Color kPrimaryColor = Color(0xFF6366F1); // Indigo
const Color kSecondaryColor = Color(0xFF8B5CF6); // Purple
const Color kAccentColor = Color(0xFFF59E0B); // Amber

// Background gradients
const LinearGradient kBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF8FAFC), // Light grey
    Color(0xFFE2E8F0), // Slightly darker grey
  ],
);

const LinearGradient kDarkBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1E293B), // Dark slate
    Color(0xFF0F172A), // Darker slate
  ],
);

// Button gradients
const LinearGradient kPrimaryButtonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    kPrimaryColor,
    kSecondaryColor,
  ],
);

const LinearGradient kSecondaryButtonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF64748B), // Slate
    Color(0xFF475569), // Darker slate
  ],
);

// Card gradients
const LinearGradient kCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white,
    Color(0xFFF1F5F9), // Very light grey
  ],
);

const LinearGradient kDarkCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF334155), // Dark grey
    Color(0xFF1E293B), // Darker grey
  ],
);

// Success and error colors
const Color kSuccessColor = Color(0xFF10B981); // Emerald
const Color kErrorColor = Color(0xFFEF4444); // Red
const Color kWarningColor = Color(0xFFF59E0B); // Amber

// Text colors
const Color kTextPrimary = Color(0xFF1E293B); // Dark slate
const Color kTextSecondary = Color(0xFF64748B); // Slate
const Color kTextLight = Color(0xFF94A3B8); // Light slate

// Shadow colors
const Color kShadowColor = Color(0x1A000000); // Black with low opacity
const Color kShadowColorDark = Color(0x33000000); // Black with medium opacity
