import 'package:flutter/widgets.dart';
import 'package:habit_tracker/features/habits/models/app_settings.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
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

  /* -------------------------------------------------------------------------- */
  /*                                  HABITS                                    */
  /* -------------------------------------------------------------------------- */

  final List<Habit> _habits = [];

  /// Public getter (safe)
  List<Habit> get habits => List.unmodifiable(_habits);

  /// Create habit
  Future<void> createHabit(String habitName) async {
    final habit = Habit()..name = habitName;

    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });

    await getAllHabits();
  }

  /* -------------------------------------------------------------------------- */
  /*                               HEATMAP DATA                                 */
  /* -------------------------------------------------------------------------- */

  DateTime? _firstLaunchDate;
  final Map<DateTime, int> _heatMapDataset = {};

  // Getters
  DateTime? get firstLaunchDate => _firstLaunchDate;
  Map<DateTime, int> get heatMapDataset => Map.unmodifiable(_heatMapDataset);

  /// Read all habits and calculate heatmap dataset
  Future<void> getAllHabits() async {
    final data = await isar.habits.where().findAll();

    _habits
      ..clear()
      ..addAll(data);

    // Calculate heatmap dataset
    _heatMapDataset.clear();
    for (var habit in _habits) {
      for (var date in habit.completedDays) {
        final normalizedDate = _normalizeDate(date);
        if (_heatMapDataset.containsKey(normalizedDate)) {
          _heatMapDataset[normalizedDate] =
              _heatMapDataset[normalizedDate]! + 1;
        } else {
          _heatMapDataset[normalizedDate] = 1;
        }
      }
    }

    // Load first launch date if null
    if (_firstLaunchDate == null) {
      final settings = await isar.appSettings.where().findFirst();
      _firstLaunchDate = settings?.firstLaunchDate ?? DateTime.now();
    }

    notifyListeners();
  }

  /// Update habit completion for today
  Future<void> updateHabitCompletion(int habitId, bool isCompleted) async {
    final habit = await isar.habits.get(habitId);
    if (habit == null) return;

    final today = _normalizeDate(DateTime.now());

    await isar.writeTxn(() async {
      if (isCompleted) {
        if (!habit.completedDays.any((date) => _isSameDay(date, today))) {
          habit.completedDays.add(today);
        }
      } else {
        habit.completedDays.removeWhere((date) => _isSameDay(date, today));
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

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
