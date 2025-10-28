// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milk_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MilkState {
  List<MilkRecord> get records =>
      throw _privateConstructorUsedError; // All milk records loaded
  bool get isLoading => throw _privateConstructorUsedError; // Loading state
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of MilkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MilkStateCopyWith<MilkState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MilkStateCopyWith<$Res> {
  factory $MilkStateCopyWith(MilkState value, $Res Function(MilkState) then) =
      _$MilkStateCopyWithImpl<$Res, MilkState>;
  @useResult
  $Res call({List<MilkRecord> records, bool isLoading, String? error});
}

/// @nodoc
class _$MilkStateCopyWithImpl<$Res, $Val extends MilkState>
    implements $MilkStateCopyWith<$Res> {
  _$MilkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MilkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<MilkRecord>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MilkStateImplCopyWith<$Res>
    implements $MilkStateCopyWith<$Res> {
  factory _$$MilkStateImplCopyWith(
          _$MilkStateImpl value, $Res Function(_$MilkStateImpl) then) =
      __$$MilkStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MilkRecord> records, bool isLoading, String? error});
}

/// @nodoc
class __$$MilkStateImplCopyWithImpl<$Res>
    extends _$MilkStateCopyWithImpl<$Res, _$MilkStateImpl>
    implements _$$MilkStateImplCopyWith<$Res> {
  __$$MilkStateImplCopyWithImpl(
      _$MilkStateImpl _value, $Res Function(_$MilkStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MilkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$MilkStateImpl(
      records: null == records
          ? _value._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<MilkRecord>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MilkStateImpl implements _MilkState {
  const _$MilkStateImpl(
      {final List<MilkRecord> records = const [],
      this.isLoading = false,
      this.error})
      : _records = records;

  final List<MilkRecord> _records;
  @override
  @JsonKey()
  List<MilkRecord> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

// All milk records loaded
  @override
  @JsonKey()
  final bool isLoading;
// Loading state
  @override
  final String? error;

  @override
  String toString() {
    return 'MilkState(records: $records, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MilkStateImpl &&
            const DeepCollectionEquality().equals(other._records, _records) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_records), isLoading, error);

  /// Create a copy of MilkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MilkStateImplCopyWith<_$MilkStateImpl> get copyWith =>
      __$$MilkStateImplCopyWithImpl<_$MilkStateImpl>(this, _$identity);
}

abstract class _MilkState implements MilkState {
  const factory _MilkState(
      {final List<MilkRecord> records,
      final bool isLoading,
      final String? error}) = _$MilkStateImpl;

  @override
  List<MilkRecord> get records; // All milk records loaded
  @override
  bool get isLoading; // Loading state
  @override
  String? get error;

  /// Create a copy of MilkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MilkStateImplCopyWith<_$MilkStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
