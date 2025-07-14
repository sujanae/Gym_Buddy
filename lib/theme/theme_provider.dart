import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  MaterialColor _primaryColor = Colors.green;

  ThemeMode get themeMode => _themeMode;
  MaterialColor get primaryColor => _primaryColor;

  void setTheme(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }

  void toggleSystemTheme(Brightness brightness) {
    _themeMode = brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
