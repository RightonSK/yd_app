// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesRecordImpl _$$SalesRecordImplFromJson(Map<String, dynamic> json) =>
    _$SalesRecordImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      sellerId: json['sellerId'] as String,
      soldAt: DateTime.parse(json['soldAt'] as String),
    );

Map<String, dynamic> _$$SalesRecordImplToJson(_$SalesRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'sellerId': instance.sellerId,
      'soldAt': instance.soldAt.toIso8601String(),
    };
