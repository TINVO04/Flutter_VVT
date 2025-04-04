import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Thay UserAPIService bằng DatabaseHelper
import '../model/user.dart';
import 'user_list_item.dart';
import 'user_form.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final userMaps = await DatabaseHelper.instance.getUsers(); // Thay bằng DatabaseHelper
      setState(() {
        _users = userMaps.map((map) => User.fromMap(map)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đụ má, lỗi khi lấy danh sách user: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách người dùng"),
      ),
      body: _users.isEmpty
          ? const Center(child: Text("Chưa có người dùng nào!"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return UserListItem(
            user: _users[index],
            onDelete: _loadUsers, // Refresh danh sách sau khi xóa
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const User_Form()),
          ).then((_) {
            _loadUsers(); // Refresh danh sách sau khi thêm user
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}