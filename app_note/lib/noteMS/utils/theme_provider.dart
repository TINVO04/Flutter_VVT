import 'package:flutter/material.dart';
import '../utils/themes.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}