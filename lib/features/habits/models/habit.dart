import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completedDays = [];

  /// Computed completion map keyed by `yyyy-MM-dd`.
  @Ignore()
  Map<String, bool> get completionStatus {
    final map = <String, bool>{};
    for (var date in completedDays) {
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      map[key] = true;
    }
    return map;
  }
}
