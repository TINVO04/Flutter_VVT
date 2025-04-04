import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/features/list/models/list_input_model.dart';

final listController = Provider.autoDispose((ref) {
  return _ListController(ref);
});

class _ListController {
  _ListController(this.ref);

  final Ref ref;

  void onPressedCheckButton(int id, bool isCompleted) {
    ref.read(listInputModel).update(id, isCompleted);
  }
}
