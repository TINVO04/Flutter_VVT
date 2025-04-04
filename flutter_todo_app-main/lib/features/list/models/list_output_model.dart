import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database.dart';
import 'package:todo/services/db/todo_database_provider.dart';

final listOutputModel =
    StreamProvider.autoDispose.family<List<Task>, bool>((ref, isCompleted) {
  return ref.watch(databaseProvider).taskDao.watchIsCompleted(isCompleted);
});
