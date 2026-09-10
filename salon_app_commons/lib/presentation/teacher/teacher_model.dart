import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class TeacherModel extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  List<PurchaseHistory>? purchaseHistories;
  TeacherCommissionRate commissionRate = TeacherCommissionRate(
    commissionRate: 0.1,
    totalAmount: 0,
  );
  List<TeacherCommissionReference> references = [];

  Future<void> init() async {
    await fetchUser();
    notifyListeners();

    await fetchPurchaseHistory();
    notifyListeners();

    await Future.wait([
      fetchTeacherCommissionReferences(),
      fetchTeacherCommission(),
    ]);
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    user = await UserRepository().fetchMyUser();
  }

  Future<void> fetchTeacherCommissionReferences() async {
    references =
        await TeacherCommissionRepository().fetchCommissionRateReferences();
  }

  Future<void> fetchTeacherCommission() async {
    final userId = user?.id;

    if (userId == null) {
      assert(false, 'userId is null');
      return;
    }
    commissionRate =
        await TeacherCommissionRepository().fetchCommissionRate(userId);
  }

  Future<void> fetchPurchaseHistory() async {
    final userId = user?.id;

    if (userId == null) {
      assert(false, 'userId is null');
      return;
    }
    final histories =
        await UserRepository().fetchPurchaseHistories(userId: userId);
    purchaseHistories = histories;
  }

  Future redirectToStripeAccountLink() async {
    final url = await StripeRepository().createStripeAccountAndGetLink();
    await URLUtils.launch(urlString: url, shouldOpenNewTab: false);
  }

  // Express ダッシュボードに飛ぶ
  // https://stripe.com/docs/connect/integrate-express-dashboard
  // https://stripe.com/docs/api/account/create_login_link
  Future redirectToStripeExpress(String accountId) async {
    final url = await StripeRepository().createStripeLoginLink(accountId);
    await URLUtils.launch(urlString: url, shouldOpenNewTab: false);
  }
}
