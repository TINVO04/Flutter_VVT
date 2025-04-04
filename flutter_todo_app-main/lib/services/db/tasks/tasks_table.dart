import 'package:drift/drift.dart';
import 'package:todo/common/enum/priority.dart';

class Tasks extends Table {
  // タスクID(Primary Key)
  IntColumn get id => integer().autoIncrement()();
  // タスク名
  TextColumn get title => text().withLength(max: 50)();
  // タスク内容
  TextColumn get content => text()();
  // タスク完了済みか
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  // 優先度
  IntColumn get priority => intEnum<Priority>()();
  // 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
