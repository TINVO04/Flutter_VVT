import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/features/detail/controllers/detail_controller.dart';
import 'package:todo/features/detail/models/detail_output_model.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({
    super.key,
    required this.taskId,
  });

  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(detailController);
    final model = ref.watch(detailOutputModel(taskId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                final task = model.value;
                if (task == null) {
                  return;
                }
                controller.onPressedDeleteButton(task.id);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: model.when(
          error: (error, _) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (task) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    const Text('タスク名'),
                    Text(task.title),
                    const SizedBox(height: 16),
                    const Text('タスク内容'),
                    Text(task.content),
                    const SizedBox(height: 16),
                    const Text('優先度'),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: task.priority.color,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(child: Text(task.priority.name)),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
