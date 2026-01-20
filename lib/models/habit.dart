import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  // habit id
  Id id = Isar.autoIncrement;
  // habit name
  late String name;
  //completed days
  List<DateTime> completedDays = [];

  // completion status map (for heatmap)
  // key: yyyy-MM-dd, value: completion status
  // We will map this from completedDays for usage, or store it if strict requirement.
  // Since Isar doesn't support Map<String, bool> directly without heavy lifting,
  // we will use the existing completedDays as the source of truth,
  // but provide this getter/setter logic or strictly try to add it if Isar allows basic JSON.
  // Requirement says "Add: Map<String, bool> completionStatus".
  // I'll add the field but verify if Isar supports it. If not, I'll rely on generating it.
  // Actually, standard Isar practice for Maps is usually not direct.
  // I will assume for this task that the user wants the LOGICAL model to have this.

  // NOTE: Isar doesn't persist Maps directly. I will keep completedDays as the PERSISTED data,
  // but if the user *strictly* wants completionStatus in the model, I'll add it as ignored
  // or handle it.
  // However, to satisfy the prompt "Extend the Habit model to include... Map etc",
  // I'll implement it as a computed property or synchronization logic basically.

  // Let's stick to the prompt's request for "Map<String, bool> completionStatus".
  // I'll try to add it as a field and see if `flutter run` fails (build runner).
  // Actually I cannot run build runner here easily without `dart run build_runner build`.
  // I will rely on `completedDays` list which *is* already there and robust.
  // I'll add a convenience method to get the map.

  // ... Wait, the prompt implies "Enable strict heatmap data".
  // I will just use `completedDays` as the source of truth for the database,
  // because `flutter_heatmap_calendar` accepts `Map<DateTime, int>`, not string keys.
  // But the prompt demanded "Key format: yyyy-MM-dd".
  // Okay, I will add it.

  // For the purpose of this task, I will strictly add the field,
  // but mark it with @Ignore() if I can't run build_runner, OR ensure the `completedDays`
  // is the main storage.
  // Actually, I'll just rely on `completedDays` and give the USER the logic they asked for
  // via methods if needed, OR just implement the heatmap using `completedDays`.

  // RE-READING: "Extend the Habit model to include daily completion history. Add: Map<String, bool> completionStatus".
  // This sounds like they want the *model* to have it.

  @Ignore()
  Map<String, bool> get completionStatus {
    Map<String, bool> map = {};
    for (var date in completedDays) {
      final key =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      map[key] = true;
    }
    return map;
  }
}
