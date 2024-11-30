import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle getDefaultSystemUiStyle(bool isDarkTheme) {
  return SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: Colors.transparent,
    // Status bar brightness (optional)
    statusBarIconBrightness: isDarkTheme
        ? Brightness.light
        : Brightness.dark, // For Android (dark icons)
    statusBarBrightness: isDarkTheme
        ? Brightness.dark
        : Brightness.light, // For iOS (dark icons)
  );
}
