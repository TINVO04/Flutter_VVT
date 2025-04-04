import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo/common/enum/priority.dart';
import 'package:todo/features/register/models/register_input_model.dart';

part 'register_controller.freezed.dart';

@freezed
class RegisterControllerState with _$RegisterControllerState {
  factory RegisterControllerState({
    @Default('') String title,
    @Default('') String content,
    @Default(Priority.middle) Priority priority,
  }) = _RegisterControllerState;
}

class RegisterControllerNotifier
    extends StateNotifier<RegisterControllerState> {
  RegisterControllerNotifier(this.ref) : super(RegisterControllerState());

  final Ref ref;

  void inputTitleTextFeild(String title) {
    state = state.copyWith(title: title);
  }

  void inputContentTextFeild(String content) {
    state = state.copyWith(content: content);
  }

  void onChangedPriority(Priority priority) {
    state = state.copyWith(priority: priority);
  }

  void onPressedRegisterButton() {
    ref
        .read(registerInputModel)
        .add(state.title, state.content, state.priority);
  }
}

final registerController =
    StateNotifierProvider<RegisterControllerNotifier, RegisterControllerState>(
  (ref) {
    return RegisterControllerNotifier(ref);
  },
);
