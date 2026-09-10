import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class SelectPlanModel extends ChangeNotifier {
  bool isLoading = false;
  User? user;
  List<Plan>? plans;
  Price? selectedPrice;
  IntervalType selectedIntervalType = IntervalType.month;
  double? trainingPlanAvailableCount;

  final _planRepo = PlanRepository();
  final _userRepo = UserRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init(BuildContext context,
      Future Function(BuildContext context)? initForInAppPurchase) async {
    startLoading();

    await _fetchUser();
    await _fetchPlanList();
    await _fetchTrainingPlanAvailableCount();

    if (initForInAppPurchase != null) {
      await initForInAppPurchase(context);
    }

    endLoading();
  }

  Future _fetchUser() async {
    user = await _userRepo.fetchMyUser();

    // ユーザー情報が取得できない場合はリトライする
    int retryCount = 0;
    while (user?.stripeId == null && retryCount < 3) {
      await Future.delayed(const Duration(seconds: 1));
      user = await _userRepo.fetchMyUser();
      retryCount++;
      logger.d('retryCount: $retryCount');
    }
  }

  /// プラン一覧を取得する
  Future _fetchPlanList() async {
    plans = await _planRepo.fetchMonthlySubscriptionPlans();
    selectedPrice = plans?.firstOrNull?.availablePrices.firstOrNull;
    logger.d('plans: count=${plans?.length}');
  }

  void select(Price price) {
    selectedPrice = price;
    notifyListeners();
  }

  void selectInterval(IntervalType intervalType) {
    selectedIntervalType = intervalType;
    notifyListeners();
  }

  Plan? getSelectedPlan() {
    return plans?.firstWhereOrNull(
      (plan) => plan.availablePrices.contains(selectedPrice),
    );
  }

  Future<void> _fetchTrainingPlanAvailableCount() async {
    try {
      final info = await InfoRepository().fetch();
      trainingPlanAvailableCount = info.trainingPlanAvailableCount;
      notifyListeners();
    } catch (e) {
      logger.d(e);
    }
  }
}
