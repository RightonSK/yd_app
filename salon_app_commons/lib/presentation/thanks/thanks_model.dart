import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ThanksModel extends ChangeNotifier {
  AbstractSubscription? subscription;
  bool isLoading = false;

  final _userRepo = UserRepository();

  void init() async {
    await fetchSubscription();
    await AnalyticsUtils.sendLog(AnalyticsEvent.screenCompletePayment);
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// ユーザを取得する
  Future fetchSubscription() async {
    startLoading();

    // 時間差でまだfirestoreが入ってないことがあるので５回までリトライする
    for (int i = 0; i < 5; i++) {
      subscription = await _userRepo.fetchSubscriptionFlesh();
      if (subscription != null) {
        break;
      }
      await Future.delayed(const Duration(seconds: 2));
    }

    endLoading();
  }
}
