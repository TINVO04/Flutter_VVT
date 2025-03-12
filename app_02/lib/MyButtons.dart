import "package:flutter/material.dart";

class MyButtons extends StatelessWidget {
  const MyButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App 02"),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
          children: [
            ElevatedButton(
              onPressed: () {
                print("Click me!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("Click me!"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text("Button 2", style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                print("Button 3");
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text("Button 3"),
            ),
            SizedBox(height: 20),
            IconButton(
              onPressed: () {
                print("Icon tim");
              },
              icon: Icon(Icons.favorite, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Click me! 2");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("Click me!"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                print("Yêu Thích 1");
              },
              icon: Icon(Icons.favorite, color: Colors.red),
              label: Text('Yêu Thích'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                print("Yêu Thích 2");
              },
              icon: Icon(Icons.favorite, color: Colors.red),
              label: Text('Yêu Thích'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                print("InkWell được nhấn!");
              },
              splashColor: Colors.blue.withOpacity(0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: Text("Button tùy chỉnh với Inkwell"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        backgroundColor: Colors.purple[100],
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}