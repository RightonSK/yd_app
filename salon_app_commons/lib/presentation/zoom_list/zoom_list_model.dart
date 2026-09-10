import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ZoomListModel extends ChangeNotifier {
  bool isPaidError = false;
  bool isLoading = true;
  bool isButtonLoading = false;
  bool isMeetingTime = false;
  List<Event>? events;
  AbstractSubscription? subscription;

  bool get isFlutterTrainingPlan {
    final subscription = this.subscription;
    if (subscription == null) {
      return false;
    }
    return subscription.planType == PlanType.training;
  }

  final _userRepo = UserRepository();
  final _eventRepo = EventRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init(BuildContext context) async {
    final subscription = await _userRepo.fetchSubscriptionFlesh();
    this.subscription = subscription;
    isPaidError = subscription?.isErrorStatus ?? false;

    events = await _eventRepo.fetchAllEvents();
    endLoading();
  }
}
