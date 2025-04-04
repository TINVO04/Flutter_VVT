import 'dart:io';
import 'package:flutter/material.dart';
import '../api/user_api_service.dart';
import '../model/user.dart';
import 'user_detail_screen.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;

  const UserListItem({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: user.profileImagePath != null
            ? CircleAvatar(
          backgroundImage: FileImage(File(user.profileImagePath!)),
        )
            : CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(user.name ?? 'Không có tên'), // Fix lỗi: cung cấp giá trị mặc định
        subtitle: Text("Email: ${user.email ?? 'Không có email'}"), // Fix lỗi: cung cấp giá trị mặc định
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailScreen(user: user, isEdit: true),
                  ),
                ).then((_) {
                  onDelete(); // Refresh danh sách sau khi chỉnh sửa
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Xác nhận xóa"),
                    content: Text("Mày có chắc muốn xóa ${user.name ?? 'người dùng này'} không?"), // Fix lỗi: cung cấp giá trị mặc định
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await UserAPIService.instance.deleteUser(user.id!);
                            Navigator.pop(context); // Đóng dialog
                            onDelete(); // Refresh danh sách
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã xóa ${user.name ?? 'người dùng'} thành công!")), // Fix lỗi: cung cấp giá trị mặc định
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đụ má, lỗi khi xóa user: $e")),
                            );
                          }
                        },
                        child: Text("Xóa", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user, isEdit: false),
            ),
          );
        },
      ),
    );
  }
}