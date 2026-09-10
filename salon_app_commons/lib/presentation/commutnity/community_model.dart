import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class CommunityModel extends ChangeNotifier {
  CommunityModel() {
    _init();
  }

  List<NotificationData>? notifications;
  List<User>? members;
  List<UserApp>? appList;
  List<FUTTransaction>? futTransactions;
  List<User>? futRankingMembers;

  bool isLoading = false;

  final _notificationRepo = NotificationRepository();
  final _memberRepo = UserRepository();
  final _appsRepo = UserAppsRepository();
  final _futRepo = FUTTransactionRepository();

  Future _init() async {
    await fetchNotifications();
    await fetchMembers();
    await fetchApps();
    await fetchFUTs();
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

  Future<void> fetchMembers() async {
    members = await _memberRepo.fetchMembers();
  }

  Future<void> fetchNotifications() async {
    notifications = await _notificationRepo.fetchOnly(1);
  }

  Future<void> fetchApps() async {
    appList = await _appsRepo.fetchAppsList();
  }

  Future<void> fetchFUTs() async {
    final today = DateTime.now();
    final k28daysAgo = today.add(const Duration(days: -28));
    futTransactions = await _futRepo.fetchAfter(k28daysAgo);
    futRankingMembers = _futRepo.createFUTRankingMembers(
      futTransactions ?? [],
      members ?? [],
      FUTGroup.week,
    );
  }
}
