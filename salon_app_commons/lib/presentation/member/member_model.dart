import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../widget/member_list.dart';

class MemberModel extends ChangeNotifier {
  MemberModel({List<User>? members}) {
    if (members != null) {
      // 元の配列に影響がないようにコピーする
      this.members = [...members];
    }
    _init();
  }

  List<User>? members;
  final _repository = UserRepository();
  MemberSortType currentSortType = MemberSortType.createdAt;

  Future _init() async {
    if (members != null) {
      return;
    }
    try {
      members = await _repository.fetchMembers();
      notifyListeners();
    } catch (e) {
      logger.d(e);
      throw ('エラーが発生しました');
    }
  }

  void sortBy(MemberSortType sortType) {
    if (members == null) {
      return;
    }
    currentSortType = sortType;
    switch (sortType) {
      case MemberSortType.createdAt:
        members!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case MemberSortType.point:
        members!.sort((a, b) => b.coinAmount.compareTo(a.coinAmount));
        break;
      case MemberSortType.githubContribution:
        members!.sort(
            (a, b) => b.githubContribution.compareTo(a.githubContribution));
        break;
    }
    notifyListeners();
  }
}
