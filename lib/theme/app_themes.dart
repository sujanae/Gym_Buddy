import 'package:flutter/material.dart';

class AppThemeData {
  final String name;
  final MaterialColor color;

  AppThemeData(this.name, this.color);
}

class AppThemes {
  static final List<AppThemeData> themes = [
    AppThemeData("Green", Colors.green),
    AppThemeData("Blue", Colors.blue),
    AppThemeData("Red", Colors.red),
    AppThemeData("Purple", Colors.purple),
    AppThemeData("Orange", Colors.orange),
  ];
}
