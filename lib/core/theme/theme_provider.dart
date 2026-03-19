import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeModeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme() async {
    if (_themeMode == ThemeMode.light ||
        (_themeMode == ThemeMode.system && !isDarkMode)) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeModeKey,
      _themeMode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);

    if (themeString == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeString == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
