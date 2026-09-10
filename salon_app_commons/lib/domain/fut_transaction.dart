import 'package:cloud_firestore/cloud_firestore.dart';

class FUTTransaction {
  /// コレクション名
  static const name = 'fut_transactions';

  final String id;
  final String from;
  final String to;
  int coinAmount;
  final String reason;
  final DateTime createdAt;

  FUTTransaction._({
    required this.id,
    required this.from,
    required this.to,
    required this.coinAmount,
    required this.reason,
    required this.createdAt,
  });

  factory FUTTransaction.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;

    return FUTTransaction._(
      id: doc.id,
      from: data[FUTTransactionField.from],
      to: data[FUTTransactionField.to],
      coinAmount: data[FUTTransactionField.coinAmount],
      reason: data[FUTTransactionField.reason],
      createdAt: data[FUTTransactionField.createdAt]?.toDate(),
    );
  }
}

class FUTTransactionField {
  static const from = 'from';
  static const to = 'to';
  static const coinAmount = 'coinAmount';
  static const reason = 'reason';
  static const createdAt = 'createdAt';
}
