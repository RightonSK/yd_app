import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GithubRankingModel extends ChangeNotifier {
  GithubRankingModel(TickerProvider vsync, int tabLength, List<User> members) {
    tabController = TabController(length: tabLength, vsync: vsync);
    tabController.addListener(() {
      switchMyIndex(tabController.index);
    });

    // 元の配列に影響がないようにコピーする
    final allMembers = [...members]
      ..sort((a, b) => b.githubContribution.compareTo(a.githubContribution));

    final dailyRanking = [...members]
        .map(
            (e) => e.copyWith(newGithubContribution: e.dailyGithubContribution))
        .toList()
      ..sort((a, b) => b.githubContribution.compareTo(a.githubContribution));

    final weeklyRanking = [...members]
        .map((e) =>
            e.copyWith(newGithubContribution: e.weeklyGithubContribution))
        .toList()
      ..sort((a, b) => b.githubContribution.compareTo(a.githubContribution));

    final monthlyRanking = [...members]
        .map((e) =>
            e.copyWith(newGithubContribution: e.monthlyGithubContribution))
        .toList()
      ..sort((a, b) => b.githubContribution.compareTo(a.githubContribution));

    rankings = [
      dailyRanking,
      weeklyRanking,
      monthlyRanking,
      allMembers,
    ];

    fetchMyUser();
  }
  late TabController tabController;
  late List<List<User>> rankings;
  User? myUser;
  int? myIndex;

  Future fetchMyUser() async {
    myUser = await UserRepository().fetchMyUser();
    myIndex = rankings.first.indexWhere((user) => user.id == myUser?.id);
    myUser = myUser?.copyWith(
        newGithubContribution: rankings.first[myIndex!].githubContribution);
    notifyListeners();
  }

  void switchMyIndex(int tabIndex) {
    myIndex = rankings[tabIndex].indexWhere((user) => user.id == myUser?.id);
    myUser = myUser?.copyWith(
        newGithubContribution: rankings[tabIndex][myIndex!].githubContribution);
    notifyListeners();
  }
}
