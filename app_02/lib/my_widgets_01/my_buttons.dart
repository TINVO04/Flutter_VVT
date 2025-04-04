import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  const MyButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App 02'),
        backgroundColor: Colors.pink,
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
            icon: Icon(Icons.info),
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
            ElevatedButton(
              onPressed: () {
                print('Click me!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: Text(
                'Click me!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text('Button 2', style: TextStyle(fontSize: 24)),
            ),

            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {},
              child: Text('Button 2', style: TextStyle(fontSize: 24)),
            ),

            SizedBox(height: 20),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite),
              color: Colors.black,
            ),

            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(Icons.add),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Click me!');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
              ),
              child: Text(
                'Click me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.favorite),
              label: Text('Yêu Thích'),
            ),

            SizedBox(height: 20),
            InkWell(
              onTap: () {
                print('InkWell clicked');
              },
              splashColor: Colors.blue.withOpacity(0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: Text('Click InWell kakaka'),
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
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm Kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá Nhân'),
        ],
      ),
    );
  }
}
