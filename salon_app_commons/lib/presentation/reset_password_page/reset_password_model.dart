import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ResetPasswordModel extends ChangeNotifier {
  String mail = '';
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future resetPassword() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: mail,
      );
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      throw UserRepository.errorMessage(e);
    }
  }
}
