import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class BadgeListModel extends ChangeNotifier {
  BadgeListModel({this.badges}) {
    if (badges == null) {
      startLoading();
      fetchUserBadges();
      endLoading();
    }
  }

  List<UserBadge>? badges;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserBadges() async {
    final user = await UserRepository().fetchMyUser();
    badges = user?.badges;
    notifyListeners();
  }
}
