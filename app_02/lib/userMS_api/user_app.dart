import 'package:app_02/userMS_api/view/login_screen.dart';
import 'package:app_02/userMS_api/view/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  // Kiểm tra trạng thái đăng nhập và trả về màn hình phù hợp
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      return UserListScreen(
        onLogout: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        },
      );
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}