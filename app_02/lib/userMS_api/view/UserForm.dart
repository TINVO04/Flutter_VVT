import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/User.dart'; // Cập nhật import

// Widget UserForm để tái sử dụng form nhập thông tin người dùng.
// Nhận một User (nếu chỉnh sửa) và một callback onSubmit để trả dữ liệu về widget cha.
class UserForm extends StatefulWidget {
  final User? user; // User hiện tại (nếu chỉnh sửa)
  final Function(User, File?) onSubmit; // Callback để trả dữ liệu về widget cha

  const UserForm({super.key, this.user, required this.onSubmit});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _dateController;
  String? _selectedCity;
  String? _gender;
  final List<String> cities = ['Hà Nội', 'TP.HCM', 'Đà Nẵng', 'Cần Thơ'];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSubmitted = false;
  bool _isAgreed = false;
  DateTime? _selectedDate;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị từ user (nếu có)
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _passwordController = TextEditingController(text: widget.user?.password ?? '');
    _confirmPasswordController = TextEditingController(text: widget.user?.password ?? '');
    _dateController = TextEditingController(text: widget.user?.birthDate ?? '');
    _selectedCity = widget.user?.city;
    _gender = widget.user?.gender;
    if (widget.user?.profileImagePath != null) {
      _profileImage = File(widget.user!.profileImagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Ảnh đại diện
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
              child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            )
                : ClipOval(
              child: Image.file(
                _profileImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Họ và Tên
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Họ và Tên",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Không được để trống!';
              }
              if (value.length < 5) {
                return 'Tối thiểu 5 ký tự!';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Ngày sinh
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: "Ngày sinh",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _dateController.text = pickedDate.toString().split(' ')[0];
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Chọn ngày sinh đi!';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email không được để trống!';
              }
              if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                return 'Email không hợp lệ!';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Số điện thoại
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: "Số điện thoại",
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Số điện thoại không được để trống!';
              }
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Số điện thoại phải là 10 chữ số!';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Thành phố
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Thành phố",
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(),
            ),
            value: _selectedCity,
            items: cities.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCity = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Chọn thành phố đi!';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Giới tính
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _isSubmitted && _gender == null ? Colors.red : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: FormField<String>(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn giới tính';
                }
                return null;
              },
              initialValue: _gender,
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Text(
                        "Giới tính",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Nam',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value;
                                  state.didChange(value);
                                });
                              },
                            ),
                            const Text('Nam'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Nữ',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value;
                                  state.didChange(value);
                                });
                              },
                            ),
                            const Text('Nữ'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Khác',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value;
                                  state.didChange(value);
                                });
                              },
                            ),
                            const Text('Khác'),
                          ],
                        ),
                      ],
                    ),
                    if (_isSubmitted && state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Mật khẩu
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: "Mật khẩu",
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mật khẩu không được để trống!';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải ít nhất 6 ký tự!';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _isPasswordVisible = value.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 20),
          // Nhập lại mật khẩu
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Nhập lại mật khẩu",
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: !_isConfirmPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nhập lại mật khẩu đi!';
              }
              if (value != _passwordController.text) {
                return 'Mật khẩu không khớp!';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _isConfirmPasswordVisible = value.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 20),
          // Đồng ý điều khoản
          CheckboxListTile(
            title: const Text("Đồng ý với điều khoản"),
            value: _isAgreed,
            onChanged: (value) {
              setState(() {
                _isAgreed = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          // Nút Submit
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSubmitted = true;
              });
              if (_formKey.currentState!.validate() && _isAgreed) {
                final user = User(
                  id: widget.user?.id,
                  name: _nameController.text,
                  birthDate: _dateController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  city: _selectedCity ?? '',
                  gender: _gender ?? '',
                  password: _passwordController.text,
                  profileImagePath: _profileImage?.path,
                );
                widget.onSubmit(user, _profileImage);
              } else if (!_isAgreed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Phải đồng ý với điều khoản trước!")),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}