// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesRecord _$SalesRecordFromJson(Map<String, dynamic> json) {
  return _SalesRecord.fromJson(json);
}

/// @nodoc
mixin _$SalesRecord {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  DateTime get soldAt => throw _privateConstructorUsedError;

  /// Serializes this SalesRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesRecordCopyWith<SalesRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesRecordCopyWith<$Res> {
  factory $SalesRecordCopyWith(
    SalesRecord value,
    $Res Function(SalesRecord) then,
  ) = _$SalesRecordCopyWithImpl<$Res, SalesRecord>;
  @useResult
  $Res call({
    String id,
    String productId,
    int quantity,
    String sellerId,
    DateTime soldAt,
  });
}

/// @nodoc
class _$SalesRecordCopyWithImpl<$Res, $Val extends SalesRecord>
    implements $SalesRecordCopyWith<$Res> {
  _$SalesRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? sellerId = null,
    Object? soldAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            sellerId: null == sellerId
                ? _value.sellerId
                : sellerId // ignore: cast_nullable_to_non_nullable
                      as String,
            soldAt: null == soldAt
                ? _value.soldAt
                : soldAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalesRecordImplCopyWith<$Res>
    implements $SalesRecordCopyWith<$Res> {
  factory _$$SalesRecordImplCopyWith(
    _$SalesRecordImpl value,
    $Res Function(_$SalesRecordImpl) then,
  ) = __$$SalesRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    int quantity,
    String sellerId,
    DateTime soldAt,
  });
}

/// @nodoc
class __$$SalesRecordImplCopyWithImpl<$Res>
    extends _$SalesRecordCopyWithImpl<$Res, _$SalesRecordImpl>
    implements _$$SalesRecordImplCopyWith<$Res> {
  __$$SalesRecordImplCopyWithImpl(
    _$SalesRecordImpl _value,
    $Res Function(_$SalesRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? sellerId = null,
    Object? soldAt = null,
  }) {
    return _then(
      _$SalesRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        sellerId: null == sellerId
            ? _value.sellerId
            : sellerId // ignore: cast_nullable_to_non_nullable
                  as String,
        soldAt: null == soldAt
            ? _value.soldAt
            : soldAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesRecordImpl implements _SalesRecord {
  const _$SalesRecordImpl({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.sellerId,
    required this.soldAt,
  });

  factory _$SalesRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final int quantity;
  @override
  final String sellerId;
  @override
  final DateTime soldAt;

  @override
  String toString() {
    return 'SalesRecord(id: $id, productId: $productId, quantity: $quantity, sellerId: $sellerId, soldAt: $soldAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, productId, quantity, sellerId, soldAt);

  /// Create a copy of SalesRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesRecordImplCopyWith<_$SalesRecordImpl> get copyWith =>
      __$$SalesRecordImplCopyWithImpl<_$SalesRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesRecordImplToJson(this);
  }
}

abstract class _SalesRecord implements SalesRecord {
  const factory _SalesRecord({
    required final String id,
    required final String productId,
    required final int quantity,
    required final String sellerId,
    required final DateTime soldAt,
  }) = _$SalesRecordImpl;

  factory _SalesRecord.fromJson(Map<String, dynamic> json) =
      _$SalesRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  int get quantity;
  @override
  String get sellerId;
  @override
  DateTime get soldAt;

  /// Create a copy of SalesRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesRecordImplCopyWith<_$SalesRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
