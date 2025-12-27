import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/design_system.dart';

/// Theme provider for managing app theme state
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';

  bool _isDarkMode = false;
  bool _isInitialized = false;

  /// Whether dark mode is enabled
  bool get isDarkMode => _isDarkMode;

  /// Whether the theme has been loaded from preferences
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  /// Load saved theme preference
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Default to light theme on error
      _isDarkMode = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Theme toggle still works even if save fails
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Set theme explicitly
  Future<void> setTheme({required bool isDark}) async {
    if (_isDarkMode == isDark) return;

    _isDarkMode = isDark;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Get the current ThemeData based on theme mode
  ThemeData get themeData {
    return _isDarkMode ? AppTheme.dark : AppTheme.light;
  }

  /// Get the current brightness
  Brightness get brightness {
    return _isDarkMode ? Brightness.dark : Brightness.light;
  }

  /// Get the current color scheme
  ColorScheme get colorScheme {
    return _isDarkMode ? darkColorScheme : lightColorScheme;
  }

  /// Get the theme mode for MaterialApp
  ThemeMode get themeMode {
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
