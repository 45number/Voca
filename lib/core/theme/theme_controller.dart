import 'package:flutter/material.dart';

final themeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;

    notifyListeners();
  }

  void setFromDatabase(int value) {
    switch (value) {
      case 1:
        _themeMode = ThemeMode.light;
        break;

      case 2:
        _themeMode = ThemeMode.dark;
        break;

      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }
}
