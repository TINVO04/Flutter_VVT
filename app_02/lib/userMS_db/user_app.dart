import 'package:app_02/userMS_api/view/user_list_screen.dart';
import 'package:flutter/material.dart';

class UserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}