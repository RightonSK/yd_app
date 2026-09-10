import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistory {
  final String id;
  final String? purchaser; // id
  final String? purchaserNickname; // nickname for display
  final String? mentorPlanId;
  final DateTime? purchasedAt;
  final int? price;
  final String? paymentId;
  final int? fut;
  final String? requestFUTTransactionId;
  final double? commissionRate;

  PurchaseHistory(
    this.id,
    this.purchasedAt,
    this.purchaser,
    this.mentorPlanId,
    this.price,
    this.paymentId,
    this.fut,
    this.requestFUTTransactionId,
    this.commissionRate, {
    this.purchaserNickname,
  });

  factory PurchaseHistory.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PurchaseHistory(
      doc.id,
      _toDate(data, 'purchasedAt'),
      data['purchaser'],
      data['mentorPlanId'],
      data['price'],
      data['paymentId'],
      data['FUT'],
      data['requestFUTTransactionId'],
      data['commissionRate'],
    );
  }

  /// Create PurchaseHistory with nickname
  factory PurchaseHistory.withNickname(
    PurchaseHistory original, 
    String? nickname,
  ) {
    return PurchaseHistory(
      original.id,
      original.purchasedAt,
      original.purchaser,
      original.mentorPlanId,
      original.price,
      original.paymentId,
      original.fut,
      original.requestFUTTransactionId,
      original.commissionRate,
      purchaserNickname: nickname,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purchasedAt'] = purchasedAt;
    data['purchaser'] = purchaser;
    data['mentorPlanId'] = mentorPlanId;
    data['price'] = price;
    data['paymentId'] = paymentId;
    data['FUT'] = fut;
    data['requestFUTTransactionId'] = requestFUTTransactionId;
    data['commissionRate'] = commissionRate;
    return data;
  }

  /// Timestamp => DateTime
  static DateTime? _toDate(Map<String, dynamic> data, String fieldName) {
    DateTime? dTime;
    if (data[fieldName] is Timestamp) {
      dTime = (data[fieldName] as Timestamp).toDate();
    }
    return dTime;
  }
}
