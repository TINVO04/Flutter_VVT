import 'package:flutter/material.dart';

class MyGerures extends StatelessWidget {
  const MyGerures({super.key});

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

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                print('Widthget duoc chon!!!');
              },
              onDoubleTap: () {
                print('Widthget duoc chon 2 em!!!');
              },
              onLongPress: () {
                print('Widthget duoc giu!!!');
              },
              onPanUpdate: (details) {
                print('Widthget di chuyen!!! ${details.delta}');
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.yellow,
                child: Center(child: Text('click em!!!')),
              ),
            ),
          ],
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
