import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyNameUpdateModel extends ChangeNotifier {
  String newName = '';
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateName() async {
    if (newName.isEmpty) {
      throw ('ニックネームを入力してください');
    }
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update(
        {
          'nickname': newName,
        },
      );
    } catch (e) {
      logger.d(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
