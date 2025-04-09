//
//
// import 'package:app_02/userMS_api/user_app.dart';
// import 'package:flutter/material.dart';
//
//
// void main() {
//   runApp(
//     MaterialApp(
//       home: SafeArea(child: UserApp()),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'noteMS/data/repositories/note_repository.dart';
import 'noteMS/presentation/providers/note_provider.dart';
import 'noteMS/presentation/screens/note_list/note_list_screen.dart';
import 'noteMS/utils/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo repository mà không cần NoteDatabaseHelper
    final repository = NoteRepositoryImpl();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider(repository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Danh sách ghi chú',
            theme: themeProvider.themeData,
            home: NoteListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
