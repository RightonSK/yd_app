import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyFUTModel extends ChangeNotifier {
  bool isLoading = false;
  int? fut;
  User? user;
  List<FUTTransaction>? futTransactions;

  final _userRepo = UserRepository();
  final _futRepo = FUTTransactionRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// ユーザを取得する
  Future fetchUserAndTransaction() async {
    startLoading();
    final user = await _userRepo.fetchMyUser();
    this.user = user;
    fut = user!.coinAmount;

    final transactions = await _futRepo.fetchMyFUTTransactions(user.id);
    futTransactions = transactions;

    endLoading();
  }

  /// 交換する
  /// Tシャツ 3000 マグカップ 1000 ステッカー500
  Future exchangeToGoods(FUTReasons reason) async {
    if (user == null || user?.coinAmount == 0) {
      throw 'まずはFUTを貯めましょう';
    }

    final goodsPrice = reason.futAmount!; // マイナスの値
    final newFUT = user!.coinAmount + goodsPrice;

    if (newFUT < 0) {
      throw 'FUTが足りません';
    }

    await _futRepo.addConsumeTransaction(
      uid: user!.id,
      coinAmount: -goodsPrice, // transactionはプラスで良いので-をつける
      reason: reason,
    );
    await _userRepo.incrementUserFUT(goodsPrice);
  }
}
