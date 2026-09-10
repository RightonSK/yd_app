import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class SignUpModel extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// 入会登録
  Future signUp(String email, String password, String? inviteId) async {
    await UserRepository().signUp(
      email,
      password,
      inviteId,
    );
  }

  /// メールアドレス認証メールの送信
  Future sendVerification() async {
    await UserRepository().sendVerification();
  }
}
