import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/functions_repository.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class SlackInputModel extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// SlackEmailを更新する
  Future updateEmail(String slackEmail) async {
    final slackId = await _validateSlackEmail(slackEmail);
    await UserRepository().updateSlackEmail(
      slackEmail: slackEmail,
      slackId: slackId,
    );
  }

  Future reloadUserState() async {
    await UserRepository().reloadUserState(
      firebaseUser: FirebaseAuth.instance.currentUser,
    );
  }

  /// SlackEmailが有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  Future _validateSlackEmail(String email) async {
    if (email.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    return await FunctionsRepository().validateSlackEmail(email);
  }
}
