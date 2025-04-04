import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database.dart';
import 'package:todo/services/db/todo_database_provider.dart';

final detailOutputModel =
    FutureProvider.autoDispose.family<Task, int>((ref, id) async {
  return await ref.watch(databaseProvider).taskDao.fetch(id).getSingle();
});
