import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class InviteModel extends ChangeNotifier {
  bool isLoading = false;
  String? inviteUrl;
  int? inviteCount;

  final _userRepo = UserRepository();

  void createInviteUrl() async {
    final user = await _userRepo.fetchMyUser();
    inviteUrl = '${URLUtils.getBaseUrl()}?invite_id=${user?.nickname}';
    inviteCount = user?.inviteCount;
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
}
