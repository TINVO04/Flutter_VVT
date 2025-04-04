import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database_provider.dart';

final registerOutputModel = StreamProvider.autoDispose((ref) {
  return ref.watch(databaseProvider).taskDao.watch();
});
