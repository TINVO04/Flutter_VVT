import 'package:app_02/userMS_api/api/user_api_service.dart';
import 'package:app_02/userMS_api/view/login_screen.dart';
import 'package:app_02/userMS_api/view/user_list_item.dart';
import 'package:flutter/material.dart';
import '../model/User.dart'; // Cập nhật import
import 'AddUserScreen.dart'; // Cập nhật import

class UserListScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const UserListScreen({super.key, this.onLogout});

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
      final userMaps = await UserAPIService.instance.getUsers();
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
        actions: [
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Gọi callback onLogout để xóa SharedPreferences
                widget.onLogout!();
                // Chuyển về LoginScreen và xóa stack điều hướng
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false, // Xóa toàn bộ stack
                );
                // Hiển thị thông báo đăng xuất thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã đăng xuất thành công!")),
                );
              },
              tooltip: 'Đăng xuất',
            ),
        ],
      ),
      body: _users.isEmpty
          ? const Center(child: Text("Chưa có người dùng nào!"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return UserListItem(
            user: _users[index],
            onDelete: _loadUsers,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          ).then((_) {
            _loadUsers();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}