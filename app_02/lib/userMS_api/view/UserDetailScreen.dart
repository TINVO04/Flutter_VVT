import 'dart:io';
import 'package:flutter/material.dart';
import '../model/User.dart'; // Cập nhật import

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết người dùng"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            user.profileImagePath != null
                ? ClipOval(
              child: Image.file(
                File(user.profileImagePath!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
                : const CircleAvatar(
              child: Icon(Icons.person),
              radius: 50,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.name,
              decoration: const InputDecoration(labelText: "Họ và Tên", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.birthDate,
              decoration: const InputDecoration(labelText: "Ngày sinh", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.phone,
              decoration: const InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.city,
              decoration: const InputDecoration(labelText: "Thành phố", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.gender,
              decoration: const InputDecoration(labelText: "Giới tính", border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.password,
              decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder()),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}