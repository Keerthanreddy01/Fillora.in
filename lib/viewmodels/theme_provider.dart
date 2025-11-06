import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme mode (light/dark)
/// Handles theme persistence and provides theme switching functionality
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // If loading fails, keep system theme
      state = ThemeMode.system;
    }
  }

  /// Save theme to shared preferences
  Future<void> _saveTheme(ThemeMode theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Handle save error silently
    }
  }

  /// Switch to light theme
  Future<void> setLightTheme() async {
    state = ThemeMode.light;
    await _saveTheme(ThemeMode.light);
  }

  /// Switch to dark theme
  Future<void> setDarkTheme() async {
    state = ThemeMode.dark;
    await _saveTheme(ThemeMode.dark);
  }

  /// Switch to system theme
  Future<void> setSystemTheme() async {
    state = ThemeMode.system;
    await _saveTheme(ThemeMode.system);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
        await setLightTheme();
        break;
      case ThemeMode.system:
        await setLightTheme();
        break;
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    return state == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    return state == ThemeMode.light;
  }

  /// Check if current theme is system
  bool get isSystemMode {
    return state == ThemeMode.system;
  }
}

/// Global provider for theme management
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Provider for checking if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});

/// Provider for getting theme brightness
final brightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeProvider);
  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
});