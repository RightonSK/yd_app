import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MentorPlanListModel extends ChangeNotifier {
  bool isLoading = true;
  List<MentorPlan>? mentorPlans;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init(BuildContext context) async {
    final users = await UserRepository().fetchMembers(limit: 1000);
    mentorPlans = await MentorPlanRepository().fetchAll(users);
    endLoading();

    // お問い合わせボタンを隠す
    URLUtils.hideChannelButton();
  }
}
