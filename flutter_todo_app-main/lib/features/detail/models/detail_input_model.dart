import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database_provider.dart';

final detailInputModel = Provider.autoDispose((ref) {
  return _DetailInputModel(ref);
});

class _DetailInputModel {
  _DetailInputModel(this.ref);

  final Ref ref;

  void delete(int id) async {
    final dao = ref.read(databaseProvider).taskDao;
    final task = await dao.fetch(id).getSingle();
    dao.drop(task);
  }
}
