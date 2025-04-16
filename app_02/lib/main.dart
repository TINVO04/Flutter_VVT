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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notes_app/screens/login_screen.dart';
import 'notes_app/screens/note_list_screen.dart';
import 'notes_app/utils/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accountId') != null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Note App',
          theme: themeProvider.themeData,
          home: FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data == true) {
                return const NoteListScreen();
              }
              return const LoginScreen();
            },
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}