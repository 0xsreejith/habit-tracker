import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?) onChanged;
  final void Function(BuildContext) editHabit;
  final void Function(BuildContext) deleteHabit;
  final void Function() onTap;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green.shade50
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
            activeColor: Colors.green,
            value: isCompleted,
            onChanged: onChanged,
          ),
          title: Text(
            text,
            style: TextStyle(
              decoration: isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: isCompleted
                  ? Colors.grey
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                editHabit(context);
              } else if (value == 'delete') {
                deleteHabit(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
