import 'dart:io';
import 'package:app_02/userMS_api/api/user_api_service.dart';
import 'package:flutter/material.dart';
import '../model/User.dart';
import 'EditUserScreen.dart';
import 'UserDetailScreen.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;

  const UserListItem({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: user.profileImagePath != null
            ? CircleAvatar(
          backgroundImage: FileImage(File(user.profileImagePath!)),
          radius: 25,
        )
            : const CircleAvatar(
          child: Icon(Icons.person),
          radius: 25,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: () {
          // Khi nhấn vào user, chuyển sang màn hình chi tiết
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
            ),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit,color: Colors.indigo,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(user: user, isEdit: true),
                  ),
                ).then((_) => onDelete());
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete,color: Colors.redAccent,),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Xác nhận xóa"),
                    content: Text("Mày có chắc muốn xóa ${user.name}?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Xóa"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await UserAPIService.instance.deleteUser(user.id!);
                    onDelete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${user.name} đã bị xóa!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đụ má, lỗi khi xóa user: $e")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}