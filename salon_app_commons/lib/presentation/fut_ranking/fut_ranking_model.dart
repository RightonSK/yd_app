import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class FUTRankingModel extends ChangeNotifier {
  FUTRankingModel(TickerProvider vsync, int tabLength, List<User> members,
      List<FUTTransaction> futTransactions) {
    tabController = TabController(length: tabLength, vsync: vsync);
    tabController.addListener(() {
      switchMyIndex(tabController.index);
    });

    final dailyRanking =
        _repo.createFUTRankingMembers(futTransactions, members, FUTGroup.day);
    final weeklyRanking =
        _repo.createFUTRankingMembers(futTransactions, members, FUTGroup.week);
    final monthlyRanking =
        _repo.createFUTRankingMembers(futTransactions, members, FUTGroup.month);

    // 元の配列に影響がないようにコピーする
    final allMembers = [...members];
    allMembers.sort((a, b) => b.coinAmount.compareTo(a.coinAmount));

    rankings = [
      dailyRanking,
      weeklyRanking,
      monthlyRanking,
      allMembers,
    ];

    fetchMyUser(allMembers);
  }
  final _repo = FUTTransactionRepository();

  late TabController tabController;
  late List<List<User>> rankings;
  User? myUser;
  int? myIndex;

  Future fetchMyUser(List<User> allMembers) async {
    myUser = await UserRepository().fetchMyUser();
    myIndex = rankings.first.indexWhere((user) => user.id == myUser?.id);
    myUser =
        myUser?.copyWith(newFUTCoinAmount: rankings.first[myIndex!].coinAmount);
    notifyListeners();
  }

  void switchMyIndex(int tabIndex) {
    myIndex = rankings[tabIndex].indexWhere((user) => user.id == myUser?.id);
    myUser = myUser?.copyWith(
        newFUTCoinAmount: rankings[tabIndex][myIndex!].coinAmount);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
