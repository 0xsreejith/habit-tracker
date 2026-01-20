import 'package:flutter/widgets.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /// Initialize Isar DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  /* -------------------------------------------------------------------------- */
  /*                               APP SETTINGS                                 */
  /* -------------------------------------------------------------------------- */

  /// Save first app launch date (used for heatmap)
  Future<void> saveFirstDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()
        ..firstLaunchDate = _normalizeDate(DateTime.now());

      await isar.writeTxn(() async {
        await isar.appSettings.put(settings);
      });
    }
  }

  /// Get first app launch date
  Future<DateTime?> getFirstDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /* -------------------------------------------------------------------------- */
  /*                                  HABITS                                    */
  /* -------------------------------------------------------------------------- */

  final List<Habit> _habits = [];

  /// Public getter (safe)
  List<Habit> get habits => _habits;

  /// Create habit
  Future<void> createHabit(String habitName) async {
    final habit = Habit()..name = habitName;

    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });

    await getAllHabits();
  }

  /// Read all habits
  Future<void> getAllHabits() async {
    final data = await isar.habits.where().findAll();

    _habits
      ..clear()
      ..addAll(data);

    notifyListeners();
  }

  /// Update habit completion for today
  Future<void> updateHabitCompletion(int habitId, bool isCompleted) async {
    final habit = await isar.habits.get(habitId);
    if (habit == null) return;

    final today = _normalizeDate(DateTime.now());

    await isar.writeTxn(() async {
      // Logic: Save today's completion status, Preserve previous dates
      // If checks, add today if not present
      if (isCompleted) {
        if (!habit.completedDays.any(
          (date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day,
        )) {
          habit.completedDays.add(today);
        }
      }
      // If unchecks, remove today
      else {
        habit.completedDays.removeWhere(
          (date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day,
        );
      }

      await isar.habits.put(habit);
    });

    await getAllHabits();
  }

  /// Update habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    await getAllHabits();
  }

  /// Delete habit
  Future<void> deleteHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(habit.id);
    });

    await getAllHabits();
  }

  /* -------------------------------------------------------------------------- */
  /*                               UTIL FUNCTIONS                               */
  /* -------------------------------------------------------------------------- */

  /// Normalize date (important for heatmap & comparisons)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
