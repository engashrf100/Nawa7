// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top_main_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TopMainState {
  AuthStatus get status => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  ValidationErrors? get validationErrors => throw _privateConstructorUsedError;

  /// Create a copy of TopMainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopMainStateCopyWith<TopMainState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopMainStateCopyWith<$Res> {
  factory $TopMainStateCopyWith(
    TopMainState value,
    $Res Function(TopMainState) then,
  ) = _$TopMainStateCopyWithImpl<$Res, TopMainState>;
  @useResult
  $Res call({
    AuthStatus status,
    UserModel? user,
    String? message,
    ValidationErrors? validationErrors,
  });
}

/// @nodoc
class _$TopMainStateCopyWithImpl<$Res, $Val extends TopMainState>
    implements $TopMainStateCopyWith<$Res> {
  _$TopMainStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopMainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? validationErrors = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AuthStatus,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            validationErrors: freezed == validationErrors
                ? _value.validationErrors
                : validationErrors // ignore: cast_nullable_to_non_nullable
                      as ValidationErrors?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopMainStateImplCopyWith<$Res>
    implements $TopMainStateCopyWith<$Res> {
  factory _$$TopMainStateImplCopyWith(
    _$TopMainStateImpl value,
    $Res Function(_$TopMainStateImpl) then,
  ) = __$$TopMainStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AuthStatus status,
    UserModel? user,
    String? message,
    ValidationErrors? validationErrors,
  });
}

/// @nodoc
class __$$TopMainStateImplCopyWithImpl<$Res>
    extends _$TopMainStateCopyWithImpl<$Res, _$TopMainStateImpl>
    implements _$$TopMainStateImplCopyWith<$Res> {
  __$$TopMainStateImplCopyWithImpl(
    _$TopMainStateImpl _value,
    $Res Function(_$TopMainStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopMainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? validationErrors = freezed,
  }) {
    return _then(
      _$TopMainStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AuthStatus,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        validationErrors: freezed == validationErrors
            ? _value.validationErrors
            : validationErrors // ignore: cast_nullable_to_non_nullable
                  as ValidationErrors?,
      ),
    );
  }
}

/// @nodoc

class _$TopMainStateImpl implements _TopMainState {
  const _$TopMainStateImpl({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
    this.validationErrors,
  });

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  final UserModel? user;
  @override
  final String? message;
  @override
  final ValidationErrors? validationErrors;

  @override
  String toString() {
    return 'TopMainState(status: $status, user: $user, message: $message, validationErrors: $validationErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopMainStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.validationErrors, validationErrors) ||
                other.validationErrors == validationErrors));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, user, message, validationErrors);

  /// Create a copy of TopMainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopMainStateImplCopyWith<_$TopMainStateImpl> get copyWith =>
      __$$TopMainStateImplCopyWithImpl<_$TopMainStateImpl>(this, _$identity);
}

abstract class _TopMainState implements TopMainState {
  const factory _TopMainState({
    final AuthStatus status,
    final UserModel? user,
    final String? message,
    final ValidationErrors? validationErrors,
  }) = _$TopMainStateImpl;

  @override
  AuthStatus get status;
  @override
  UserModel? get user;
  @override
  String? get message;
  @override
  ValidationErrors? get validationErrors;

  /// Create a copy of TopMainState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopMainStateImplCopyWith<_$TopMainStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
