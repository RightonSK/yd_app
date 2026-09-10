import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class LPModel extends ChangeNotifier {
  bool isMobile = false;
  DeviceScreenType? deviceScreenType;
  bool isShowingMobileMenu = false;
  List<Plan>? plans;
  List<UserApp>? userApps;
  List<Feed>? recentUsersFeeds;
  double? peopleCount;
  bool shouldStartCountUp = false;
  IntervalType selectedIntervalType = IntervalType.month;
  bool? isMaintenanceMode;
  double? trainingPlanAvailableCount;

  bool isLoading = false;
  bool isLoadingForGithub = false;

  final CarouselController appsCarouselController = CarouselController();
  final CarouselController usersCarouselController = CarouselController();
  final CarouselController topCarouselController = CarouselController();

  void setSizingInformation(SizingInformation information) {
    final isMobile = checkIsMobile(information);
    this.isMobile = isMobile;
    deviceScreenType = information.deviceScreenType;
  }

  void toggleShowingMobileMenu() {
    isShowingMobileMenu = !isShowingMobileMenu;
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

  void startLoadingForGithub() {
    isLoadingForGithub = true;
    notifyListeners();
  }

  void endLoadingForGithub() {
    isLoadingForGithub = false;
    notifyListeners();
  }

  Future<void> fetchApps() async {
    try {
      userApps = await UserAppsRepository().fetchAppsList();
      notifyListeners();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> fetchPlans() async {
    try {
      plans = await PlanRepository().fetchMonthlySubscriptionPlans();
      notifyListeners();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> fetchPeopleCount() async {
    try {
      final info = await InfoRepository().fetch();
      peopleCount = info.peopleCount;
      isMaintenanceMode = info.isMaintenanceMode;
      trainingPlanAvailableCount = info.trainingPlanAvailableCount;

      notifyListeners();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> fetchRecentUsers() async {
    try {
      recentUsersFeeds = await FeedRepository().fetchNewMemberFeeds();
      notifyListeners();
    } catch (e) {
      logger.d(e);
    }
  }

  void startCountUpPeople() {
    if (shouldStartCountUp) {
      return;
    }
    if (peopleCount == null) {
      return;
    }
    shouldStartCountUp = true;
    notifyListeners();
  }

  void selectInterval(IntervalType intervalType) {
    selectedIntervalType = intervalType;
    notifyListeners();
  }

  Future loginWithGitHub({String? inviteId}) async {
    await UserRepository().loginOrSignUpWithGitHub(inviteId: inviteId);
  }
}
