//
//
// import 'package:app_02/userMS_db/view/user_list_screen.dart';
// import 'package:flutter/material.dart';
//
//
// void main() {
//   runApp(
//     MaterialApp(
//       home: SafeArea(child: UserListScreen()),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'noteMS/data/database/note_database_helper.dart';
import 'noteMS/data/repositories/note_repository_impl.dart';
import 'noteMS/presentation/providers/note_provider.dart';
import 'noteMS/presentation/screens/note_list/note_list_screen.dart';
import 'noteMS/utils/theme_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbHelper = NoteDatabaseHelper.instance;
    final repository = NoteRepositoryImpl(dbHelper);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider(repository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Quản lý ghi chú',
            theme: themeProvider.themeData,
            home: NoteListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

