import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GithubInputModel extends ChangeNotifier {
  bool isLoading = false;

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
}
