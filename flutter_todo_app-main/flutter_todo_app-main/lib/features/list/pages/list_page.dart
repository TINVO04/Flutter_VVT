import 'package:flutter/material.dart';
import 'package:todo/features/list/pages/widgets/list_child_page.dart';
import 'package:todo/features/register/pages/register_page.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '未完了'),
                Tab(text: '完了済み'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListChildPage(isCompleted: false),
                  ListChildPage(isCompleted: true),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 遷移方法再検討
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
