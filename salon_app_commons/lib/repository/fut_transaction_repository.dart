import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class FUTTransactionRepository {
  static FUTTransactionRepository? _instance;
  FUTTransactionRepository._internal();

  factory FUTTransactionRepository() {
    return _instance ??= FUTTransactionRepository._internal();
  }

  final _store = FirebaseFirestore.instance;

  List<FUTTransaction>? transactions;

  Future<List<FUTTransaction>> fetchAll([bool force = false]) async {
    if (force) {
      transactions = null;
    }
    if (transactions == null) {
      final snapshot = await _store.collection(FUTTransaction.name).get();

      return snapshot.docs.map((doc) => FUTTransaction.doc(doc)).toList();
    }
    return transactions ?? [];
  }

  Future<List<FUTTransaction>> fetchAfter(DateTime date) async {
    final snapshot = await _store
        .collection(FUTTransaction.name)
        .where(FUTTransactionField.createdAt,
            isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .get();
    return snapshot.docs.map((doc) => FUTTransaction.doc(doc)).toList();
  }

  Future<List<FUTTransaction>> fetchMyFUTTransactions(String userId) async {
    final snapshot = await _store
        .collection(FUTTransaction.name)
        .where('to', isEqualTo: userId)
        .get();
    final toTransactions =
        snapshot.docs.map((doc) => FUTTransaction.doc(doc)).toList();

    final snapshot2 = await _store
        .collection(FUTTransaction.name)
        .where('from', isEqualTo: userId)
        .get();
    final fromTransactions =
        snapshot2.docs.map((doc) => FUTTransaction.doc(doc)).toList();
    fromTransactions.forEach((transaction) {
      // 自分が送った取引はマイナスにする
      transaction.coinAmount = -transaction.coinAmount;
    });

    final transactions = toTransactions + fromTransactions;
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  Future addConsumeTransaction({
    required String uid,
    required int coinAmount,
    required FUTReasons reason,
  }) async {
    Map<String, dynamic> data = {
      FUTTransactionField.from: uid,
      FUTTransactionField.to: 'flutteruniv', // 運営を示す
      FUTTransactionField.coinAmount: coinAmount,
      FUTTransactionField.reason: reason.toString(),
      FUTTransactionField.createdAt: Timestamp.now(),
    };

    await _store.collection(FUTTransaction.name).add(data);
  }

  Future<bool> checkIsExistSameTransaction1HourAgo({
    required String uid,
    required FUTReasons reasonType,
  }) async {
    final now = DateTime.now();
    final oneHourAgo = now.add(const Duration(minutes: 60) * -1);

    // 60分以内にも同じ理由のFUTを得ていないかチェック
    final snapshot = await _store
        .collection(FUTTransaction.name)
        .where(FUTTransactionField.to, isEqualTo: uid)
        .where(FUTTransactionField.createdAt, isGreaterThan: oneHourAgo)
        .where(FUTTransactionField.reason, isEqualTo: reasonType.toString())
        .limit(1)
        .get();
    final hasData = snapshot.docs.isNotEmpty;
    logger.d(hasData);
    return hasData;
  }

  Future addObtainTransaction({
    required String uid,
    required int coinAmount,
    required FUTReasons reason,
  }) async {
    Map<String, dynamic> data = {
      FUTTransactionField.from: 'flutteruniv', // 運営を示す
      FUTTransactionField.to: uid,
      FUTTransactionField.coinAmount: coinAmount,
      FUTTransactionField.reason: reason.toString(),
      FUTTransactionField.createdAt: Timestamp.now(),
    };

    await _store.collection(FUTTransaction.name).add(data);
  }

  List<User> createFUTRankingMembers(List<FUTTransaction> futTransactions,
      List<User> members, FUTGroup group) {
    final filterTransactions = futTransactions
        .where((transaction) => transaction.createdAt.isAfter(group.toDate()))
        .toList();
    // idでsortする
    filterTransactions.sort((a, b) => b.to.compareTo(a.to));
    // 同じtoでグループ分け
    String? previousTo;
    List<List<FUTTransaction>> futGroups = [];
    filterTransactions.forEach((transaction) {
      if (transaction.to == 'flutteruniv') {
        return;
      }

      if (transaction.to == previousTo) {
        futGroups[futGroups.length - 1].add(transaction);
      } else {
        futGroups.add([transaction]);
      }
      previousTo = transaction.to;
    });
    // coinAmountの合計が大きい順に並べる
    futGroups.sort((a, b) => _sumCoinAmount(b).compareTo(_sumCoinAmount(a)));
    final List<User?> futRankingMembers = futGroups.map((group) {
      final id = group.first.to;
      final user = members.firstWhereOrNull(
          (member) => member.id == id); // 一致するmemberがいなければnull
      final copyUser = user?.copyWith(newFUTCoinAmount: _sumCoinAmount(group));
      return copyUser;
    }).toList();
    return futRankingMembers.whereNotNull().toList();
  }

  int _sumCoinAmount(List<FUTTransaction> transactions) {
    int sum = 0;
    transactions.forEach((transaction) {
      sum += transaction.coinAmount;
    });
    return sum;
  }
}

enum FUTGroup {
  day,
  week,
  month;

  DateTime toDate() {
    switch (this) {
      case day:
        return DateTime.now().add(const Duration(days: -1));
      case week:
        return DateTime.now().add(const Duration(days: -7));
      case month:
        return DateTime.now().add(const Duration(days: -28));
    }
  }
}
