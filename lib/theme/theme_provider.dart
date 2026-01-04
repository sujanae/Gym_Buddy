import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _keyTheme = 'isDarkMode';
  final Box _box;

  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider(this._box) {
    _isDarkMode = _box.get(_keyTheme, defaultValue: true);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put(_keyTheme, _isDarkMode);
    notifyListeners();
  }
}
