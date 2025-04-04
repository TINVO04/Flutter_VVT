import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database_provider.dart';

final listInputModel = Provider.autoDispose((ref) {
  return _ListInputModel(ref);
});

class _ListInputModel {
  _ListInputModel(this.ref);

  final Ref ref;

  void update(int id, bool isCompleted) async {
    final dao = ref.read(databaseProvider).taskDao;
    final oldTask = await dao.fetch(id).getSingle();
    final newTask = oldTask.copyWith(
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );
    dao.renew(newTask);
  }
}
