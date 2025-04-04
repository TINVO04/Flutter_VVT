import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/enum/priority.dart';
import 'package:todo/features/register/controllers/register_controller.dart';
import 'package:todo/features/register/models/register_output_model.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(registerController.notifier);

    ref.listen(registerOutputModel, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('エラーが発生しました')));
      }

      // TODO: 比較方法再検討
      if (prev?.value == null || next.value == null) {
        return;
      }
      final int prevLength = prev?.value?.length ?? 0;
      final int nextLength = next.value?.length ?? 0;
      if (!(prevLength < nextLength)) {
        return;
      }

      // TODO: commonのtoastWidget作成する
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const SimpleDialog(
            title: Center(child: Text('登録しました')),
            children: [Center(child: Text('タスクを完了させましょう！'))],
          );
        },
      );
      Future.delayed(const Duration(seconds: 1)).then((_) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Registor')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('タスク名'),
                TextField(
                  onChanged: (text) => controller.inputTitleTextFeild(text),
                  maxLength: 50,
                  maxLines: 1,
                ),
                const Text('タスク内容'),
                TextField(
                  onChanged: (text) => controller.inputContentTextFeild(text),
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                const Text('優先度'),
                const SizedBox(height: 16),
                CupertinoSegmentedControl(
                  children: {
                    Priority.low: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(Priority.low.name),
                    ),
                    Priority.middle: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(Priority.middle.name),
                    ),
                    Priority.high: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(Priority.high.name),
                    ),
                  },
                  onValueChanged: (value) {
                    controller.onChangedPriority(value);
                  },
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    controller.onPressedRegisterButton();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('登録'),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
