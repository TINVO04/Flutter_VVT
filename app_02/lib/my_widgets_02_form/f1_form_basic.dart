import 'package:flutter/material.dart';

class FormBasicDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormBasicDemoState();
}

class _FormBasicDemoState extends State<FormBasicDemo> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController =
      TextEditingController(); // Controller cho SDT (thêm mới)
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController(); // Controller cho nhập lại mật khẩu (thêm mới)
  String? _name;
  String? _email;
  String? _phone; // Biến lưu SDT (thêm mới)
  String? _password;
  String? _confirmPassword; // Biến lưu nhập lại mật khẩu (thêm mới)
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible =
      false; // Biến toggle cho nhập lại mật khẩu (thêm mới)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Basic Demo")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextFormField để nhập họ tên
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nhập Họ và Tên: ",
                  hintText: "Nhập Họ và Tên Mày Vào Đây!!!",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Đụ má, không được để trống!';
                  }
                  if (value.length < 5) {
                    return 'Đụ mẹ, nhập ít nhất 5 ký tự!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 20),
              // TextFormField để nhập email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Đụ mẹ, email không được để trống!';
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  ).hasMatch(value)) {
                    return 'Đụ má, email không hợp lệ!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 20),
              // TextFormField để nhập số điện thoại (thêm mới)
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                  hintText: "Nhập số điện thoại của mày",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Đụ mẹ, số điện thoại không được để trống!';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Đụ má, số điện thoại phải là 10 chữ số!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value;
                },
              ),
              SizedBox(height: 20),
              // TextFormField để nhập mật khẩu
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  hintText: "Nhập mật khẩu của mày",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Đụ mẹ, mật khẩu không được để trống!';
                  }
                  if (value.length < 6) {
                    return 'Đụ má, mật khẩu phải ít nhất 6 ký tự!';
                  }
                  // Bỏ phần validate "Mật khẩu không khớp" với email
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 20),
              // TextFormField để nhập lại mật khẩu (thêm mới)
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
                  hintText: "Nhập lại mật khẩu của mày",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Đụ mẹ, nhập lại mật khẩu đi!';
                  }
                  if (value != _passwordController.text) {
                    return 'Đụ má, mật khẩu không khớp!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value;
                },
              ),
              SizedBox(height: 20),
              // Row chứa 2 nút Submit và Reset
              Row(
                children: [
                  // Nút Submit
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Xin chào $_name, email: $_email, SDT: $_phone, mật khẩu: $_password",
                            ),
                          ),
                        );
                      }
                    },
                    child: Text("Submit"),
                  ),
                  SizedBox(width: 20),
                  // Nút Reset
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _emailController.clear();
                      _phoneController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                      setState(() {
                        _name = null;
                        _email = null;
                        _phone = null;
                        _password = null;
                        _confirmPassword = null;
                        _isPasswordVisible = false;
                        _isConfirmPasswordVisible = false;
                      });
                    },
                    child: Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
