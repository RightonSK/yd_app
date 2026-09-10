import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../extensions/cropper/ui_helper.dart'
    if (dart.library.io) '../../extensions/cropper/mobile_ui_helper.dart'
    if (dart.library.html) '../../extensions/cropper/web_ui_helper.dart';

class MyUpdateModel extends ChangeNotifier with WidgetsBindingObserver {
  MyUpdateModel({this.user}) {
    WidgetsBinding.instance.addObserver(this);
  }

  String? userPhotoUrl;
  bool isLoading = false;
  User? user;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init() async {
    isLoading = true;

    // ユーザ情報を取得する
    user = await fetchUser();
    userPhotoUrl = user?.photoUrl;
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    logger.d("didChangeAppLifecycleState(): $state");
    if (state == AppLifecycleState.resumed) {
      await init();
    }
  }

  /// ユーザを取得する
  Future<User?> fetchUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    if (!doc.exists) {
      return null;
    }
    User user = User.doc(doc);
    return user;
  }

  /// ギャラリーから画像を取得しトリミングする
  Future pickPhotoFileAndUpload(BuildContext context) async {
    final Uint8List? uint8List = await pickPhotoFile(context);

    if (uint8List == null) {
      return;
    }
    await _uploadPhoto(uint8List);

    notifyListeners();
  }

  /// プロフィール画像をアップロードする
  Future _uploadPhoto(Uint8List uint8List) async {
    final user = this.user;

    if (user == null) {
      return;
    }
    // 一時ファイルをFirebaseStorageに保存する
    final snapshot = await FirebaseStorage.instance
        .ref()
        .child("userPhoto/${user.id}")
        .putData(uint8List);

    final photoUrl = await snapshot.ref.getDownloadURL();

    final document =
        FirebaseFirestore.instance.collection('users').doc(user.id);
    await document.update({
      'photoUrl': photoUrl,
    });
    userPhotoUrl = photoUrl;
    notifyListeners();
  }

  /// Firebase上のプロフィール画像を削除する
  Future deletePhoto() async {
    if (userPhotoUrl == null) {
      throw ('プロフィール画像はありません');
    }

    try {
      // FirestoreのphotoUrlを空にする
      final document =
          FirebaseFirestore.instance.collection('users').doc(user!.id);
      await document.update({
        'photoUrl': null,
      });

      // Firestorage上のプロフィール画像を削除する
      final storage = FirebaseStorage.instance;
      await storage.ref().child("userPhoto/${user!.id}").delete();

      userPhotoUrl = null;
      notifyListeners();
    } catch (e) {
      logger.d(e.toString());
      throw ('エラーが発生しました');
    }
  }

  //登録都道府県を変更する
  Future<void> changeUserPrefecture(Prefecture selected) async {
    startLoading();
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update(
        {
          'prefecture': selected.value,
        },
      );
      user = await fetchUser();
    } catch (e) {
      logger.d(e.toString());
      throw ('エラーが発生しました');
    } finally {
      endLoading();
      notifyListeners();
    }
  }
}
