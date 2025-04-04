import 'package:flutter/material.dart';

class MyTextField2 extends StatefulWidget {
  const MyTextField2({super.key});

  @override
  State<MyTextField2> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField2> {
  final _hoTenController = TextEditingController();
  final _emailController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _sdtController = TextEditingController();
  final _matKhauController = TextEditingController();
  String _hoTenText = '';
  String _emailText = '';
  String _diaChiText = '';
  String _sdtText = '';
  String _matKhauText = '';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _hoTenController.dispose();
    _emailController.dispose();
    _diaChiController.dispose();
    _sdtController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Fix bàn phím đè, đù má
      appBar: AppBar(
        title: Text("App 02"),
        backgroundColor: Colors.yellow, // Thay màu theo MyTextField2
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc), // Giữ icon abc như MyTextField2
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Thêm để cuộn, vãi lồn
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              TextField(
                controller: _hoTenController,
                onChanged: (value) {
                  setState(() {
                    _hoTenText = value;
                  });
                },
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập Họ Tên: $value');
                },
                decoration: InputDecoration(
                  labelText: 'Nhap ho va ten: ',
                  hintText: 'Nhập Họ Tên Mày Vào Đây!!!',
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _hoTenController.clear();
                      setState(() {
                        _hoTenText = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Bạn đã nhập Họ Tên: $_hoTenText'),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    _emailText = value;
                  });
                },
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập Email: $value');
                },
                decoration: InputDecoration(
                  labelText: 'Nhap email: ',
                  hintText: 'Nhập Email Mày Vào Đây!!!',
                  helperText: 'Email phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _emailController.clear();
                      setState(() {
                        _emailText = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.blue[100],
                ),
              ),
              SizedBox(height: 20),
              Text('Bạn đã nhập Email: $_emailText'),
              SizedBox(height: 20),
              TextField(
                controller: _diaChiController,
                onChanged: (value) {
                  setState(() {
                    _diaChiText = value;
                  });
                },
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập Địa Chỉ: $value');
                },
                decoration: InputDecoration(
                  labelText: 'Nhap Dia chi: ',
                  hintText: 'Nhập Địa Chỉ Mày Vào Đây!!!',
                  helperText: 'Địa Chỉ phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.location_city),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _diaChiController.clear();
                      setState(() {
                        _diaChiText = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Bạn đã nhập Địa Chỉ: $_diaChiText'),
              SizedBox(height: 20),
              TextField(
                controller: _sdtController,
                onChanged: (value) {
                  setState(() {
                    _sdtText = value;
                  });
                },
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập SDT: $value');
                },
                decoration: InputDecoration(
                  labelText: 'Nhap SDT: ',
                  hintText: 'Nhập Số Điện Thoại Mày Vào Đây!!!',
                  helperText: 'Số Điện Thoại phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.phone),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _sdtController.clear();
                      setState(() {
                        _sdtText = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              Text('Bạn đã nhập SDT: $_sdtText'),
              SizedBox(height: 20),
              TextField(
                controller: _matKhauController,
                onChanged: (value) {
                  setState(() {
                    _matKhauText = value;
                  });
                },
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập Mật Khẩu: $value');
                },
                obscureText: !_isPasswordVisible,
                // Toggle hiển thị mật khẩu
                decoration: InputDecoration(
                  labelText: 'Nhap mat khau: ',
                  hintText: 'Nhập Mật Khẩu Mày Vào Đây!!!',
                  helperText: 'Mật Khẩu phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.lock),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Bạn đã nhập Mật Khẩu: $_matKhauText'),
              SizedBox(height: 80),
              // Thêm khoảng trống để FAB không đè, vãi cặc
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('pressed');
        },
        child: const Icon(Icons.add_ic_call),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá Nhân'),
        ],
      ),
    );
  }
}
