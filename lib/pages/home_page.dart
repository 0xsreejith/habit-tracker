import 'package:flutter/material.dart';
import 'package:habit_tracker/components/app_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/pages/habit_detail_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).getAllHabits();
    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter habit name"),
        ),
        actions: [
          // Save Button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().createHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),

          // Cancel Button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // check habit on or off
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    // set the text controller to the habit name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          // Save Button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                newHabitName,
              );

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),

          // Cancel Button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          // Delete Button
          MaterialButton(
            onPressed: () {
              // save to db
              context.read<HabitDatabase>().deleteHabit(habit);

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          // Cancel Button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: _buildHabitList(),
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.habits;

    // return list
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
          onTap: () {
            // navigate to habit detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailPage(habit: habit),
              ),
            );
          },
        );
      },
    );
  }

  // helper to check if completed today
  bool isHabitCompletedToday(List<DateTime> completedDays) {
    final today = DateTime.now();
    return completedDays.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }
}
