import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/log_utils.dart';

class MyBioUpdateModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String newBio = '';
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
    if (newBio.isEmpty) {
      throw ('自己紹介を変更して下さい');
    }
    try {
      final firebaseUser = auth.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update(
        {
          'bio': newBio,
        },
      );
    } catch (e) {
      logger.d(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
