import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api/user_api_service.dart';
import '../model/user.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  final bool isEdit;

  const UserDetailScreen({required this.user, required this.isEdit});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _genderController;
  late TextEditingController _passwordController;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _birthDateController = TextEditingController(text: widget.user.birthDate);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _cityController = TextEditingController(text: widget.user.city);
    _genderController = TextEditingController(text: widget.user.gender);
    _passwordController = TextEditingController(text: widget.user.password);
    if (widget.user.profileImagePath != null) {
      _profileImage = File(widget.user.profileImagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Chỉnh sửa người dùng" : "Chi tiết người dùng"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.isEdit)
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _profileImage = File(image.path);
                      });
                    }
                  },
                  child: _profileImage == null
                      ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  )
                      : ClipOval(
                    child: Image.file(
                      _profileImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                _profileImage == null
                    ? CircleAvatar(child: Icon(Icons.person), radius: 50)
                    : ClipOval(
                  child: Image.file(
                    _profileImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Họ và Tên", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  if (value.length < 5) return "Tối thiểu 5 ký tự!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: "Ngày sinh", border: OutlineInputBorder()),
                readOnly: true,
                onTap: widget.isEdit
                    ? () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _birthDateController.text = pickedDate.toString().split(' ')[0];
                  }
                }
                    : null,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                    return "Email không hợp lệ!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return "Số điện thoại phải là 10 chữ số!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: "Thành phố", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: "Giới tính", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder()),
                readOnly: !widget.isEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Không được để trống!";
                  if (value.length < 6) return "Mật khẩu phải ít nhất 6 ký tự!";
                  return null;
                },
              ),
              if (widget.isEdit) ...[
                SizedBox(height: 20),
                // Trong phần ElevatedButton của nút Lưu
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedUser = User(
                        id: widget.user.id,
                        name: _nameController.text,
                        birthDate: _birthDateController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        city: _cityController.text,
                        gender: _genderController.text,
                        password: _passwordController.text,
                        profileImagePath: _profileImage?.path,
                      );
                      try {
                        await UserAPIService.instance.updateUser(widget.user.id!, updatedUser.toMap());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đã sửa ${updatedUser.name} thành công!")),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đụ má, lỗi khi sửa user: $e")),
                        );
                      }
                    }
                  },
                  child: Text("Cập Nhật"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}