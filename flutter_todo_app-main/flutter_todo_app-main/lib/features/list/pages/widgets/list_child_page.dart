import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/features/detail/pages/detail_page.dart';
import 'package:todo/features/list/models/list_output_model.dart';
import 'package:todo/features/list/pages/widgets/list_cell.dart';

class ListChildPage extends ConsumerWidget {
  const ListChildPage({
    super.key,
    required this.isCompleted,
  });

  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(listOutputModel(isCompleted));

    return model.when(
      error: (error, _) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (task) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: task.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(taskId: task[index].id),
                    ),
                  );
                },
                child: ListCell(task: task[index]),
              );
            }),
          ),
        );
      },
    );
  }
}
