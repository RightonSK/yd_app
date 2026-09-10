import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/functions_repository.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class GithubInputRecoverModel extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateGithubName(String githubName) async {
    await _validateGithubName(githubName);
    final githubId =
        await UserRepository().fetchGithubIdFromGitHubUsername(githubName);
    await UserRepository().updateGithubId(githubId, githubName);
  }

  /// Githubユーザー名が有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  Future _validateGithubName(String githubName) async {
    await FunctionsRepository().validateGithubUsername(githubName);
  }
}
