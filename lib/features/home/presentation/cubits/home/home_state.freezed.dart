// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  HomeStatus get status => throw _privateConstructorUsedError;
  HomeModel? get homeData => throw _privateConstructorUsedError;
  AppBranch? get branch => throw _privateConstructorUsedError;
  List<Branch> get allBranches =>
      throw _privateConstructorUsedError; // Combined list of all loaded branches
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMoreData => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    HomeStatus status,
    HomeModel? homeData,
    AppBranch? branch,
    List<Branch> allBranches,
    int currentPage,
    bool hasMoreData,
    String? errorMessage,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? homeData = freezed,
    Object? branch = freezed,
    Object? allBranches = null,
    Object? currentPage = null,
    Object? hasMoreData = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as HomeStatus,
            homeData: freezed == homeData
                ? _value.homeData
                : homeData // ignore: cast_nullable_to_non_nullable
                      as HomeModel?,
            branch: freezed == branch
                ? _value.branch
                : branch // ignore: cast_nullable_to_non_nullable
                      as AppBranch?,
            allBranches: null == allBranches
                ? _value.allBranches
                : allBranches // ignore: cast_nullable_to_non_nullable
                      as List<Branch>,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMoreData: null == hasMoreData
                ? _value.hasMoreData
                : hasMoreData // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HomeStatus status,
    HomeModel? homeData,
    AppBranch? branch,
    List<Branch> allBranches,
    int currentPage,
    bool hasMoreData,
    String? errorMessage,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? homeData = freezed,
    Object? branch = freezed,
    Object? allBranches = null,
    Object? currentPage = null,
    Object? hasMoreData = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$HomeStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as HomeStatus,
        homeData: freezed == homeData
            ? _value.homeData
            : homeData // ignore: cast_nullable_to_non_nullable
                  as HomeModel?,
        branch: freezed == branch
            ? _value.branch
            : branch // ignore: cast_nullable_to_non_nullable
                  as AppBranch?,
        allBranches: null == allBranches
            ? _value._allBranches
            : allBranches // ignore: cast_nullable_to_non_nullable
                  as List<Branch>,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMoreData: null == hasMoreData
            ? _value.hasMoreData
            : hasMoreData // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    this.status = HomeStatus.initial,
    this.homeData,
    this.branch,
    final List<Branch> allBranches = const [],
    this.currentPage = 1,
    this.hasMoreData = true,
    this.errorMessage,
  }) : _allBranches = allBranches;

  @override
  @JsonKey()
  final HomeStatus status;
  @override
  final HomeModel? homeData;
  @override
  final AppBranch? branch;
  final List<Branch> _allBranches;
  @override
  @JsonKey()
  List<Branch> get allBranches {
    if (_allBranches is EqualUnmodifiableListView) return _allBranches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allBranches);
  }

  // Combined list of all loaded branches
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMoreData;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HomeState(status: $status, homeData: $homeData, branch: $branch, allBranches: $allBranches, currentPage: $currentPage, hasMoreData: $hasMoreData, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.homeData, homeData) ||
                other.homeData == homeData) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            const DeepCollectionEquality().equals(
              other._allBranches,
              _allBranches,
            ) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMoreData, hasMoreData) ||
                other.hasMoreData == hasMoreData) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    homeData,
    branch,
    const DeepCollectionEquality().hash(_allBranches),
    currentPage,
    hasMoreData,
    errorMessage,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final HomeStatus status,
    final HomeModel? homeData,
    final AppBranch? branch,
    final List<Branch> allBranches,
    final int currentPage,
    final bool hasMoreData,
    final String? errorMessage,
  }) = _$HomeStateImpl;

  @override
  HomeStatus get status;
  @override
  HomeModel? get homeData;
  @override
  AppBranch? get branch;
  @override
  List<Branch> get allBranches; // Combined list of all loaded branches
  @override
  int get currentPage;
  @override
  bool get hasMoreData;
  @override
  String? get errorMessage;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
