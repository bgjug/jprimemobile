// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FavoritesState {
  Set<int> get favoriteIds => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritesStateCopyWith<FavoritesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateCopyWith(
    FavoritesState value,
    $Res Function(FavoritesState) then,
  ) = _$FavoritesStateCopyWithImpl<$Res, FavoritesState>;
  @useResult
  $Res call({Set<int> favoriteIds, bool isLoading});
}

/// @nodoc
class _$FavoritesStateCopyWithImpl<$Res, $Val extends FavoritesState>
    implements $FavoritesStateCopyWith<$Res> {
  _$FavoritesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? favoriteIds = null, Object? isLoading = null}) {
    return _then(
      _value.copyWith(
            favoriteIds: null == favoriteIds
                ? _value.favoriteIds
                : favoriteIds // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FavoritesStateImplCopyWith<$Res>
    implements $FavoritesStateCopyWith<$Res> {
  factory _$$FavoritesStateImplCopyWith(
    _$FavoritesStateImpl value,
    $Res Function(_$FavoritesStateImpl) then,
  ) = __$$FavoritesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<int> favoriteIds, bool isLoading});
}

/// @nodoc
class __$$FavoritesStateImplCopyWithImpl<$Res>
    extends _$FavoritesStateCopyWithImpl<$Res, _$FavoritesStateImpl>
    implements _$$FavoritesStateImplCopyWith<$Res> {
  __$$FavoritesStateImplCopyWithImpl(
    _$FavoritesStateImpl _value,
    $Res Function(_$FavoritesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? favoriteIds = null, Object? isLoading = null}) {
    return _then(
      _$FavoritesStateImpl(
        favoriteIds: null == favoriteIds
            ? _value._favoriteIds
            : favoriteIds // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FavoritesStateImpl implements _FavoritesState {
  const _$FavoritesStateImpl({
    required final Set<int> favoriteIds,
    required this.isLoading,
  }) : _favoriteIds = favoriteIds;

  final Set<int> _favoriteIds;
  @override
  Set<int> get favoriteIds {
    if (_favoriteIds is EqualUnmodifiableSetView) return _favoriteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_favoriteIds);
  }

  @override
  final bool isLoading;

  @override
  String toString() {
    return 'FavoritesState(favoriteIds: $favoriteIds, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesStateImpl &&
            const DeepCollectionEquality().equals(
              other._favoriteIds,
              _favoriteIds,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_favoriteIds),
    isLoading,
  );

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesStateImplCopyWith<_$FavoritesStateImpl> get copyWith =>
      __$$FavoritesStateImplCopyWithImpl<_$FavoritesStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FavoritesState implements FavoritesState {
  const factory _FavoritesState({
    required final Set<int> favoriteIds,
    required final bool isLoading,
  }) = _$FavoritesStateImpl;

  @override
  Set<int> get favoriteIds;
  @override
  bool get isLoading;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritesStateImplCopyWith<_$FavoritesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
