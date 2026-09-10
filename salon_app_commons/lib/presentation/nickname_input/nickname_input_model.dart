import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class NicknameInputModel extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// ログイン
  Future updateNickname(String nickname) async {
    // nickname
    if (nickname.isEmpty) {
      throw ('ニックネームを入力してください');
    }
    await UserRepository().updateNickname(nickname);
  }
}
