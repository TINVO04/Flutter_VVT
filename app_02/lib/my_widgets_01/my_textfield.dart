import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App 02"),
        backgroundColor: Colors.pinkAccent,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print('b1');
            },
            icon: Icon(Icons.search),
          ),

          IconButton(
            onPressed: () {
              print('b2');
            },
            icon: Icon(Icons.settings),
          ),

          IconButton(
            onPressed: () {
              print('b3');
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              TextField(
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập: $value');
                },
                onChanged: ((value) {
                  print('value: $value');
                }),
                decoration: InputDecoration(
                  label: Text('Nhap ho va ten: '),
                  hintText: 'Nhập Họ Tên Mày Vào Đây!!!',
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập: $value');
                },
                onChanged: ((value) {
                  print('value: $value');
                }),
                decoration: InputDecoration(
                  label: Text('Nhap email: '),
                  hintText: 'Nhập Email Mày Vào Đây!!!',
                  helperText: 'Email phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập: $value');
                },
                onChanged: ((value) {
                  print('value: $value');
                }),
                decoration: InputDecoration(
                  label: Text('Nhap Dia chi: '),
                  hintText: 'Nhập Địa Chỉ Mày Vào Đây!!!',
                  helperText: 'Địa Chỉ phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.location_city),
                  suffixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập: $value');
                },
                onChanged: ((value) {
                  print('value: $value');
                }),
                decoration: InputDecoration(
                  label: Text('Nhap SDT: '),
                  hintText: 'Nhập Số Điện Thoại Mày Vào Đây!!!',
                  helperText: 'Số Điện Thoại phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.phone),
                  suffixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20),
              TextField(
                onSubmitted: (value) {
                  print('Đã Hoàn Thành Nhập: $value');
                },
                onChanged: ((value) {
                  print('value: $value');
                }),
                obscureText: true,
                decoration: InputDecoration(
                  label: Text('Nhap mat khau: '),
                  hintText: 'Nhập Mật Khẩu Mày Vào Đây!!!',
                  helperText: 'Mật Khẩu phải hợp lệ!!!',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
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
