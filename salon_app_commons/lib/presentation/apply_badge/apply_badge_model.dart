import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ApplyBadgeModel extends ChangeNotifier {
  bool isLoading = false;

  final _userRepo = UserRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future applyBadge(UserBadge badge) async {
    await _userRepo.addMyBadges([badge]);
  }
}
