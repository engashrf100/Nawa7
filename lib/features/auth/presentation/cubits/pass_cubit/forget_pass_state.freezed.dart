// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forget_pass_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ForgetPassState {
  AuthStatus get status => throw _privateConstructorUsedError;
  ValidationErrors? get errors => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Create a copy of ForgetPassState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgetPassStateCopyWith<ForgetPassState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgetPassStateCopyWith<$Res> {
  factory $ForgetPassStateCopyWith(
    ForgetPassState value,
    $Res Function(ForgetPassState) then,
  ) = _$ForgetPassStateCopyWithImpl<$Res, ForgetPassState>;
  @useResult
  $Res call({AuthStatus status, ValidationErrors? errors, String? message});
}

/// @nodoc
class _$ForgetPassStateCopyWithImpl<$Res, $Val extends ForgetPassState>
    implements $ForgetPassStateCopyWith<$Res> {
  _$ForgetPassStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgetPassState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errors = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AuthStatus,
            errors: freezed == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as ValidationErrors?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgetPassStateImplCopyWith<$Res>
    implements $ForgetPassStateCopyWith<$Res> {
  factory _$$ForgetPassStateImplCopyWith(
    _$ForgetPassStateImpl value,
    $Res Function(_$ForgetPassStateImpl) then,
  ) = __$$ForgetPassStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthStatus status, ValidationErrors? errors, String? message});
}

/// @nodoc
class __$$ForgetPassStateImplCopyWithImpl<$Res>
    extends _$ForgetPassStateCopyWithImpl<$Res, _$ForgetPassStateImpl>
    implements _$$ForgetPassStateImplCopyWith<$Res> {
  __$$ForgetPassStateImplCopyWithImpl(
    _$ForgetPassStateImpl _value,
    $Res Function(_$ForgetPassStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPassState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errors = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _$ForgetPassStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AuthStatus,
        errors: freezed == errors
            ? _value.errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as ValidationErrors?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ForgetPassStateImpl implements _ForgetPassState {
  const _$ForgetPassStateImpl({
    this.status = AuthStatus.initial,
    this.errors,
    this.message,
  });

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  final ValidationErrors? errors;
  @override
  final String? message;

  @override
  String toString() {
    return 'ForgetPassState(status: $status, errors: $errors, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgetPassStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errors, errors) || other.errors == errors) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, errors, message);

  /// Create a copy of ForgetPassState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgetPassStateImplCopyWith<_$ForgetPassStateImpl> get copyWith =>
      __$$ForgetPassStateImplCopyWithImpl<_$ForgetPassStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ForgetPassState implements ForgetPassState {
  const factory _ForgetPassState({
    final AuthStatus status,
    final ValidationErrors? errors,
    final String? message,
  }) = _$ForgetPassStateImpl;

  @override
  AuthStatus get status;
  @override
  ValidationErrors? get errors;
  @override
  String? get message;

  /// Create a copy of ForgetPassState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgetPassStateImplCopyWith<_$ForgetPassStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
