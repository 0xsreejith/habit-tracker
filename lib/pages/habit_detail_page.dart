import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    // prepare heatmap dataset
    final dataset = <DateTime, int>{};
    for (var date in habit.completedDays) {
      // normalize date to remove time part, just in case
      final normalizedDate = DateTime(date.year, date.month, date.day);
      dataset[normalizedDate] = 1; // 1 means completed
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Heatmap
              HeatMap(
                startDate: DateTime.now().subtract(const Duration(days: 90)),
                endDate: DateTime.now(),
                datasets: dataset,
                colorMode: ColorMode.color,
                defaultColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.inversePrimary,
                showColorTip: false,
                showText: true,
                scrollable: true,
                size: 30,
                colorsets: {1: Colors.green},
                onClick: (value) {
                  // Optional: snackbar showing status
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(value.toString())));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
