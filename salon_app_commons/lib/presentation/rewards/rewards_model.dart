import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/rewards_repository.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class RewardsModel extends ChangeNotifier {
  bool isLoading = true;
  List<Reward>? rewards;
  AbstractSubscription? subscription;

  final _rewardRepo = RewardsRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init(BuildContext context) async {
    rewards = await _rewardRepo.fetchRewards();
    endLoading();
  }
}
