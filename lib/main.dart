import 'package:flutter/material.dart';
import 'package:habit_tracker/app/app.dart';
import 'package:habit_tracker/core/theme/theme_provider.dart';
import 'package:habit_tracker/services/habit_database.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();

  final database = HabitDatabase();
  await database.saveFirstDate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => database),
      ],
      child: const HabitTrackerApp(),
    ),
  );
}
