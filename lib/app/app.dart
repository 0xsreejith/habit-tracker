import 'package:flutter/material.dart';
import 'package:habit_tracker/core/theme/dark_mode.dart';
import 'package:habit_tracker/core/theme/light_mode.dart';
import 'package:habit_tracker/core/theme/theme_provider.dart';
import 'package:habit_tracker/features/habits/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const HomePage(),
    );
  }
}
