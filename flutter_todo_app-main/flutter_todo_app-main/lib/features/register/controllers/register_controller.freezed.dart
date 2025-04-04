// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegisterControllerState {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterControllerStateCopyWith<RegisterControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterControllerStateCopyWith<$Res> {
  factory $RegisterControllerStateCopyWith(RegisterControllerState value,
          $Res Function(RegisterControllerState) then) =
      _$RegisterControllerStateCopyWithImpl<$Res, RegisterControllerState>;
  @useResult
  $Res call({String title, String content, Priority priority});
}

/// @nodoc
class _$RegisterControllerStateCopyWithImpl<$Res,
        $Val extends RegisterControllerState>
    implements $RegisterControllerStateCopyWith<$Res> {
  _$RegisterControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegisterControllerStateCopyWith<$Res>
    implements $RegisterControllerStateCopyWith<$Res> {
  factory _$$_RegisterControllerStateCopyWith(_$_RegisterControllerState value,
          $Res Function(_$_RegisterControllerState) then) =
      __$$_RegisterControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String content, Priority priority});
}

/// @nodoc
class __$$_RegisterControllerStateCopyWithImpl<$Res>
    extends _$RegisterControllerStateCopyWithImpl<$Res,
        _$_RegisterControllerState>
    implements _$$_RegisterControllerStateCopyWith<$Res> {
  __$$_RegisterControllerStateCopyWithImpl(_$_RegisterControllerState _value,
      $Res Function(_$_RegisterControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? priority = null,
  }) {
    return _then(_$_RegisterControllerState(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
    ));
  }
}

/// @nodoc

class _$_RegisterControllerState implements _RegisterControllerState {
  _$_RegisterControllerState(
      {this.title = '', this.content = '', this.priority = Priority.middle});

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final Priority priority;

  @override
  String toString() {
    return 'RegisterControllerState(title: $title, content: $content, priority: $priority)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegisterControllerState &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, content, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegisterControllerStateCopyWith<_$_RegisterControllerState>
      get copyWith =>
          __$$_RegisterControllerStateCopyWithImpl<_$_RegisterControllerState>(
              this, _$identity);
}

abstract class _RegisterControllerState implements RegisterControllerState {
  factory _RegisterControllerState(
      {final String title,
      final String content,
      final Priority priority}) = _$_RegisterControllerState;

  @override
  String get title;
  @override
  String get content;
  @override
  Priority get priority;
  @override
  @JsonKey(ignore: true)
  _$$_RegisterControllerStateCopyWith<_$_RegisterControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
