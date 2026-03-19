import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
import 'package:habit_tracker/features/habits/presentation/widgets/app_drawer.dart';
import 'package:habit_tracker/features/habits/presentation/widgets/my_habit_tile.dart';
import 'package:habit_tracker/features/habits/presentation/widgets/my_heat_map.dart';
import 'package:habit_tracker/services/habit_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HabitDatabase>().getAllHabits();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _showHabitDialog({Habit? habit}) async {
    _textController.text = habit?.name ?? '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: habit == null ? 'Enter habit name' : 'Update habit name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newHabitName = _textController.text.trim();

              if (newHabitName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Habit name cannot be empty')),
                );
                return;
              }

              final db = context.read<HabitDatabase>();
              if (habit == null) {
                await db.createHabit(newHabitName);
              } else {
                await db.updateHabitName(habit.id, newHabitName);
              }

              if (!mounted || !dialogContext.mounted) return;
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (mounted) {
      _textController.clear();
    }
  }

  void _toggleHabitCompletion(bool? value, Habit habit) {
    if (value == null) return;
    context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
  }

  Future<void> _showDeleteHabitDialog(Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      if (!mounted) return;
      await context.read<HabitDatabase>().deleteHabit(habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    final currentHabits = habitDatabase.habits;
    final startDate = habitDatabase.firstLaunchDate ?? DateTime.now();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitDialog(),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          MyHeatMap(
            startDate: startDate,
            datasets: habitDatabase.heatMapDataset,
          ),
          ListView.builder(
            itemCount: currentHabits.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final habit = currentHabits[index];
              final isCompletedToday = _isHabitCompletedToday(
                habit.completedDays,
              );

              return MyHabitTile(
                text: habit.name,
                isCompleted: isCompletedToday,
                onChanged: (value) => _toggleHabitCompletion(value, habit),
                editHabit: (context) => _showHabitDialog(habit: habit),
                deleteHabit: (context) => _showDeleteHabitDialog(habit),
                onTap: () => _toggleHabitCompletion(!isCompletedToday, habit),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isHabitCompletedToday(List<DateTime> completedDays) {
    final today = DateTime.now();
    return completedDays.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }
}
