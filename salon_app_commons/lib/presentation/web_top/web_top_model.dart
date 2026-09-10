import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'web_top_menu.dart';

class WebTopModel extends ChangeNotifier {
  User? user;

  AbstractSubscription? subscription;
  List<StripeSubscriptionSchedule> reservations = [];

  bool shouldShowQuestionnaire = false;
  bool shouldShowSetupIsNotEnough = false;
  bool shouldShowGithubSetupIsNotEnough = false;
  bool shouldUpdateJobSeekingStatus = false;
  JobSeekingStatus? newJobSeekingStatus;

  int selectedIndex = 0;
  bool isNavigationRailOpen = true;
  bool isNew = false;

  final _userRepo = UserRepository();

  void init(String route) async {
    final foundIndex = WebTopMenu.valuesForMenu(isNew).indexWhere((value) => value.route == route);
    selectedIndex = foundIndex;

    // Fold sidebar when selectedIndex is -1 (header menu pages)
    isNavigationRailOpen = selectedIndex != -1;

    await _fetchUser();
  }

  void setIsMobile(bool isMobile) {
    // モバイルの時だけ、横を開かないようにさせる
    if (isMobile && isNavigationRailOpen) {
      isNavigationRailOpen = false;
      notifyListeners();
    }
  }

  void toggleNavigationRail() {
    isNavigationRailOpen = !isNavigationRailOpen;
    notifyListeners();
  }

  void setIndex(int index) {
    selectedIndex = index;

    final newRoute = WebTopMenu.valuesForMenu(isNew)[index].route;
    URLUtils.changeURLHistory(newRoute);
    notifyListeners();
  }

  /// Set selectedIndex to -1 for header menu pages and fold sidebar
  void setHeaderMenuIndex() {
    selectedIndex = -1;
    isNavigationRailOpen = false;
    notifyListeners();
  }

  /// ユーザを取得する
  Future _fetchUser() async {
    user = await _userRepo.fetchMyUser();

    // プラン予約をAPIから取得
    if (user != null) {
      reservations = await StripeRepository().fetchReservations(
        customerId: user!.stripeId!,
      );
      logger.d(reservations.length);
    }
    _checkIsNew();
    _checkStatusesForBar();
    notifyListeners();

    subscription = await _userRepo.fetchSubscriptionFlesh();
    notifyListeners();
  }

  // user.createdAtが1ヶ月以内かどうか
  void _checkIsNew() {
    if (user == null) {
      return;
    }
    final createdAt = user!.createdAt;
    final diff = DateTime.now().difference(createdAt);
    isNew = diff.inDays < 30;
  }

  void _checkStatusesForBar() {
    shouldShowQuestionnaire = !(user?.questionnaireAnswered ?? false);
    shouldShowSetupIsNotEnough = user?.nickname == null || user?.slackEmail == null || user?.githubId == null;
    shouldShowGithubSetupIsNotEnough = user?.githubId == null;

    // アンケートに回答したかどうかと、user?.updatedAtが3ヶ月以上昔かどうか
    final now = DateTime.now();
    final updatedAt = user?.updatedAt ?? DateTime.now();
    final diff = now.difference(updatedAt);
    shouldUpdateJobSeekingStatus = user?.jobSeekingStatus == null || diff.inDays >= 90;
  }

  void setJobSeekingStatus(JobSeekingStatus? jobSeekingStatus) {
    newJobSeekingStatus = jobSeekingStatus;
    notifyListeners();
  }

  Future updateJobSeekingStatus() async {
    final jobSeekingStatus = newJobSeekingStatus;

    if (jobSeekingStatus == null) {
      throw '転職活動中かどうかをお聞かせください🙏';
    }
    // アンケート回答フラグON
    await _userRepo.updateJobSeekingStatus(
      jobSeekingStatus: jobSeekingStatus,
    );
    _fetchUser();
  }
}
