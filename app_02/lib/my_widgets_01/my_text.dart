import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App 02"),
        backgroundColor: Colors.yellow,
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
            const SizedBox(height: 50),
            const SizedBox(height: 50),
            const Text(
              "Vo Van Tin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(wordSpacing: 1.5),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Flutter ',
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text:
                        'là một SDK phát triển ứng dụng di động nguồn mở được '
                        'tạo ra bởi Google.',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.indigo,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Flutter là một SDK phát triển ứng dụng di động nguồn mở được tạo '
              'ra bởi Google. Nó được sử dụng để phát triển ứng ứng dụng cho '
              'Android và iOS, cũng là phương thức chính để tạo ứng dụng cho '
              'Google Fuchsia.',
              maxLines: 3,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, color: Colors.black),
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
