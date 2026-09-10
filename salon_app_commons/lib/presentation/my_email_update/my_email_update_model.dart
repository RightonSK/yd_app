import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

import '../../utils/log_utils.dart';

class MyEmailUpdateModel extends ChangeNotifier {
  String userEmail = '';
  String password = '';
  bool isLoading = false;
  bool isNeedPassword = false;

  void init(email) {
    userEmail = email;
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

  Future update() async {
    final user = FirebaseAuth.instance.currentUser!;
    if (userEmail.isEmpty) {
      throw ('新しいメールアドレスを入力してください');
    }
    try {
      if (isNeedPassword) {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        ));
      }
      await user.updateEmail(userEmail);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      if (e.code == 'requires-recent-login') {
        isNeedPassword = true;
      }
      throw UserRepository.errorMessage(e);
    }
  }
}
