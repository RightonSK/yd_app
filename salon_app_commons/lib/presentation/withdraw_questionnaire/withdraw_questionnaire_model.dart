import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/repository/withdraw_repository.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class WithdrawQuestionnaireModel extends ChangeNotifier {
  AbstractSubscription? subscription;
  bool isLoading = false;
  WithdrawReason? withdrawReason;
  TextEditingController otherReasonController = TextEditingController();

  WithdrawQuestionnaireModel(this.subscription);

  /// 初期化処理
  Future init() async {
    startLoading();
    otherReasonController.addListener(notifyListeners);
    subscription ??= await UserRepository().fetchSubscriptionFlesh();
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setReason(WithdrawReason? reason) {
    withdrawReason = reason;
    notifyListeners();
  }

  bool get canSubmit {
    if (withdrawReason == null) {
      return false;
    }
    if (withdrawReason == WithdrawReason.other) {
      return otherReasonController.text.isNotEmpty;
    }
    return true;
  }

  Future withdraw(BuildContext context) async {
    final user = await UserRepository().fetchMyUser();
    final reason = withdrawReason;

    if (user == null) {
      throw 'ユーザー情報が取得できていません。画面をリロードしてください';
    }

    if (reason == null) {
      throw '退会理由をお書きください';
    }

    // 退会理由を記録
    final info = WithdrawInfo.fromUser(
      user,
      reason: reason,
      otherReasonText: otherReasonController.text,
    );
    await WithdrawRepository().setWithdrawData(info);

    final subscription = this.subscription;

    if (subscription is StripeSubscription) {
      // stripeの退会を申込む
      await StripeRepository().withdraw(customerId: user.stripeId!);
    } else {
      // APP内課金の人がいますぐやめる
      await UserRepository().deleteMyUser();
    }
  }
}
