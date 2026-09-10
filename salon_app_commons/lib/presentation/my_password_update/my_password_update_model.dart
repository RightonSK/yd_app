import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class MyPasswordUpdateModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future update() async {
    if (currentPassword.isEmpty) {
      throw ('現在のパスワードを入力してください');
    }
    if (newPassword.isEmpty) {
      throw ('新しいパスワードを入力してください');
    }
    if (newPasswordConfirm.isEmpty) {
      throw ('新しいパスワード(確認)を入力してください');
    }
    if (newPassword != newPasswordConfirm) {
      throw ('新しいパスワードと新しいパスワード(確認)を合わせてください');
    }
    if (currentPassword == newPassword) {
      throw ('現在のパスワードと新しいパスワードは別のものにしてください');
    }

    try {
      final firebaseUser = auth.currentUser!;
      await firebaseUser
          .reauthenticateWithCredential(EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: currentPassword,
      ));
      await firebaseUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw UserRepository.errorMessage(e);
    }
  }
}
