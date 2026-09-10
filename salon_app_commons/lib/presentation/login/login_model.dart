import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class LoginModel extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingForGithub = false;

  void startLoadingForGithub() {
    isLoadingForGithub = true;
    notifyListeners();
  }

  void endLoadingForGithub() {
    isLoadingForGithub = false;
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

  /// ログイン
  Future login(String email, String password) async {
    await UserRepository().login(email, password);
  }

  Future loginWithGitHub() async {
    await UserRepository().loginOrSignUpWithGitHub();
  }
}
