import 'package:drift/drift.dart';
import 'package:todo/services/db/tasks/tasks_table.dart';
import 'package:todo/services/db/todo_database.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<TodoDatabase> with _$TaskDaoMixin {
  TaskDao(TodoDatabase db) : super(db);

  Stream<List<Task>> watch() {
    return (select(tasks)).watch();
  }

  Stream<List<Task>> watchIsCompleted(bool isCompleted) {
    return (select(tasks)
          ..where((task) => task.isCompleted.equals(isCompleted)))
        .watch();
  }

  SingleSelectable<Task> fetch(int id) {
    return select(tasks)..where((task) => tasks.id.equals(id));
  }

  Future<int> add(TasksCompanion task) {
    return into(tasks).insert(task);
  }

  Future<void> renew(Task task) {
    return update(tasks).replace(task);
  }

  Future<void> drop(Task task) {
    return (delete(tasks)..where((value) => value.id.equals(task.id))).go();
  }
}
