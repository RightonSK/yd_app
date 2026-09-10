import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class UserAppDetailModel extends ChangeNotifier {
  final _memberRepo = UserRepository();

  User? member;
  List<User> members = [];
  bool isLoading = true;

  Future fetchMember(UserApp app) async {
    if (app.userIds.isNotEmpty) {
      // 複数メンバー取得
      await Future.forEach(app.userIds, (String userId) async {
        try {
          final member = await _memberRepo.fetchMember(userId);
          members.add(member);
        } catch (_) {
          // 取れないユーザーはスルーする
        }
      });
    } else if (app.userId != null && app.userId!.isNotEmpty) {
      // メンバー1人だけ取得
      try {
        final member = await _memberRepo.fetchMember(app.userId!);
        this.member = member;
      } catch (_) {
        // 取れないユーザーはスルーする
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
