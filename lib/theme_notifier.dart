import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  Color _themeColor = Colors.blue; // Default theme color

  Color get themeColor => _themeColor;

  void updateThemeColor(Color newColor) {
    _themeColor = newColor;
    notifyListeners(); // Notify listeners when the theme color changes
  }
}
