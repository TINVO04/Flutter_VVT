import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:todo/common/enum/priority.dart';
import 'package:todo/services/db/tasks/tasks_dao.dart';
import 'package:todo/services/db/tasks/tasks_table.dart';

part 'todo_database.g.dart';

// Todo Database
@DriftDatabase(tables: [Tasks], daos: [TaskDao])
class TodoDatabase extends _$TodoDatabase {
  TodoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
