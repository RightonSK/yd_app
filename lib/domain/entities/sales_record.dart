import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_record.freezed.dart';
part 'sales_record.g.dart';

@freezed
class SalesRecord with _$SalesRecord {
  const factory SalesRecord({
    required String id,
    required String productId,
    required int quantity,
    required String sellerId,
    required DateTime soldAt,
  }) = _SalesRecord;

  factory SalesRecord.fromJson(Map<String, dynamic> json) =>
      _$SalesRecordFromJson(json);
}
