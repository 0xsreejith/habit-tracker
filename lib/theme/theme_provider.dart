import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get themeData => _themeData;
 
  //is current  theme dark mode
  bool get isDarkMode => _themeData == darkMode;
  
  //toggle theme
  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }

 
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
