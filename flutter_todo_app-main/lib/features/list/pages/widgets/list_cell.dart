import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/features/list/controllers/list_controller.dart';
import 'package:todo/services/db/todo_database.dart';

class ListCell extends ConsumerWidget {
  const ListCell({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(listController);

    return SizedBox(
      height: 60,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 8,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (isChecked) {
                      if (isChecked == null) {
                        return;
                      }
                      controller.onPressedCheckButton(task.id, isChecked);
                    },
                  ),
                  Text(task.title),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: 32,
              decoration: BoxDecoration(
                color: task.priority.color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
