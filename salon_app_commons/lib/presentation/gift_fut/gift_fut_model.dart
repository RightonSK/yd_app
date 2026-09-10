import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GiftFUTModel extends ChangeNotifier {
  final textEditingController = TextEditingController(text: "");
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

  /// 相手にポイントをあげる
  Future sendFUT(final User sendUser) async {
    if (user == null || user?.coinAmount == 0) {
      throw 'まずはFUTを貯めましょう';
    }
    if (textEditingController.text.isEmpty) {
      throw '数字を入力してください';
    }

    final inputFUT = int.parse(textEditingController.text);

    final newFUT = user!.coinAmount - inputFUT;

    if (newFUT < 0) {
      throw 'FUTが足りません';
    }

    await UserRepository().requestFUTTransaction(
      myId: user!.id,
      sendUserId: sendUser.id,
      forWhat: FUTTransactionForWhat.gift.name,
      coinAmount: inputFUT,
    );
  }
}
