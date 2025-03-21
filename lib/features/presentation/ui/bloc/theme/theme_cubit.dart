import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import '../../enums.dart';

class ThemeCubit extends Cubit<AppThemeState> {
  static const String _themePreferenceKey = 'appTheme';

  ThemeCubit() : super(AppThemeState.dark) {
    _initializeTheme();
  }

  // Initialize theme based on platform
  Future<void> _initializeTheme() async {
    try {
      AppThemeState theme;

      if (kIsWeb) {
        // For Web: Load theme from cookies
        theme = _loadThemeFromCookies();
        emit(theme);
      } else {
        // For Mobile: Load theme from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final storedThemeIndex = prefs.getInt(_themePreferenceKey);

        if (storedThemeIndex != null) {
          theme = AppThemeState.values[storedThemeIndex];
        } else {
          // Default to dark theme if no preference is set
          theme = AppThemeState.light;
        }
        emit(theme);
      }
    } catch (e) {
      debugPrint('Error initializing theme: $e');
      emit(AppThemeState.light); // Fallback to dark theme
    }
  }

  // Toggle the theme between light and dark
  Future<void> toggleTheme() async {
    try {
      final newTheme =
          state == AppThemeState.dark
              ? AppThemeState.light
              : AppThemeState.dark;

      // Emit new theme state
      emit(newTheme);

      // Save theme based on platform
      if (kIsWeb) {
        _saveThemeToCookies(newTheme);
      } else {
        await _saveThemeToPreferences(newTheme);
      }
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }

  // Save theme to SharedPreferences (Mobile)
  Future<void> _saveThemeToPreferences(AppThemeState theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, theme.index);
    } catch (e) {
      debugPrint('Error saving theme to preferences: $e');
    }
  }

  // Save the theme to cookies (Web)
  void _saveThemeToCookies(AppThemeState theme) {
    try {
      final themeValue = theme == AppThemeState.dark ? 'dark' : 'light';
      html.document.cookie =
          '$_themePreferenceKey=$themeValue; path=/; max-age=31536000'; // Cookie lasts for 1 year
    } catch (e) {
      debugPrint('Error saving theme to cookies: $e');
    }
  }

  // Load the theme from cookies (Web)
  AppThemeState _loadThemeFromCookies() {
    try {
      final cookies = html.document.cookie ?? '';
      if (cookies.contains('appTheme=light')) {
        return AppThemeState.light;
      }
      return AppThemeState.light; // Default to dark theme
    } catch (e) {
      debugPrint('Error loading theme from cookies: $e');
      return AppThemeState.light;
    }
  }
}
