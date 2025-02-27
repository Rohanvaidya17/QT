// // lib/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _themeKey = 'theme_mode';
  final SharedPreferences prefs;
  ThemeMode _themeMode;

  ThemeProvider(this.prefs) : _themeMode = _loadThemeMode(prefs);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final isLight = prefs.getBool(_themeKey) ?? true;
    return isLight ? ThemeMode.light : ThemeMode.dark;
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    prefs.setBool(_themeKey, _themeMode == ThemeMode.light);
    notifyListeners();
  }
}