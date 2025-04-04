import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/features/detail/models/detail_input_model.dart';

final detailController = Provider.autoDispose((ref) {
  return _DetailController(ref);
});

class _DetailController {
  _DetailController(this.ref);

  final Ref ref;

  void onPressedDeleteButton(int id) {
    ref.read(detailInputModel).delete(id);
  }
}
