import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = AppThemes.lightTheme;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Tải trạng thái theme từ SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkTheme') ?? false;
    _themeData = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }

  // Chuyển đổi theme và lưu trạng thái vào SharedPreferences
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    await prefs.setBool('isDarkTheme', _isDarkMode);
    notifyListeners();
  }
}