import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/withdraw_info.dart';

// 退会理由を記録するためのリポジトリ
class WithdrawRepository {
  static WithdrawRepository? _instance;
  WithdrawRepository._internal();
  factory WithdrawRepository() {
    return _instance ??= WithdrawRepository._internal();
  }

  Future setWithdrawData(
    WithdrawInfo info,
  ) async {
    await FirebaseFirestore.instance
        .collection('withdraw_user')
        .doc(info.id)
        .set(
          info.toJson(),
          SetOptions(merge: true),
        );
  }

  Future cancel(String userId) async {
    await FirebaseFirestore.instance
        .collection('withdraw_user')
        .doc(userId)
        .delete();
  }
}
