import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// 管理画面用途
class AdminMemberRepository {
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  /// メンバーを返す
  Future<User> fetch(String userId) async {
    final callable = _functions.httpsCallable('api-getMember');
    final result = await callable.call({
      'client': 'admin',
      'userId': userId,
    });
    final json = result.data['member'] ?? {};
    final member = User.json(json['userId'], json);
    return member;
  }

  /// メンバーを一括更新する
  Future updateBulk(
    List<String> ids, {
    required String role,
  }) async {
    assert(ids.isNotEmpty);

    Map<String, dynamic> data = {
      'updatedAt': Timestamp.now(),
    };
    data['role'] = role;

    await _updateBulk(collectionName: 'users', ids: ids, data: data);
  }

  /// 一括更新する
  Future _updateBulk({
    required String collectionName,
    required List<String> ids,
    required Map<String, dynamic> data,
  }) async {
    var batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < ids.length; i++) {
      final id = ids[i];
      var ref = FirebaseFirestore.instance.collection(collectionName).doc(id);
      batch.update(ref, data);
      if ((i + 1) % 500 == 0 || i == ids.length - 1) {
        await batch.commit();
        batch = FirebaseFirestore.instance.batch();
      }
    }
  }

  Future<List<PurchaseHistory>> fetchPurchaseHistories() async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('purchaseHistory')
        .get();
    logger.d(snapshot.docs.length);

    final histories =
        snapshot.docs.map((doc) => PurchaseHistory.doc(doc)).toList();
    return histories;
  }

  Future<List<WithdrawInfo>> fetchWithdrawUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('withdraw_user').get();
    logger.d(snapshot.docs.length);

    final withdrawUsers =
        snapshot.docs.map((doc) => WithdrawInfo.doc(doc)).toList();
    return withdrawUsers;
  }
}
