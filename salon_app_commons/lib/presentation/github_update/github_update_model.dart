import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GithubUpdateModel extends ChangeNotifier {
  bool isLoading = false;
  User? user;

  Future init() async {
    user = await UserRepository().fetchMyUser();
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

  Future loginWithGithubAndUpdateGithubUsername() async {
    return UserRepository().linkWithGithubAndUpdateGithubUsername();
  }

  Future unlinkGithub() async {
    await UserRepository().unlinkGithub();
  }
}
