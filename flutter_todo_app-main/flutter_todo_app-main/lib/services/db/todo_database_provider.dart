import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/db/todo_database.dart';

final databaseProvider = Provider((ref) => TodoDatabase());
