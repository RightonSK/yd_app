import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/admin_notification.dart';
import 'storage_repository.dart';

/// Firestore Notices コレクションを操作する
class AdminNotificationRepository {
  static AdminNotificationRepository? _instance;
  AdminNotificationRepository._();
  factory AdminNotificationRepository() {
    return _instance ??= AdminNotificationRepository._();
  }

  final _storage = StorageRepository();

  /// お知らせ一覧を返す
  Future<List<AdminNotification>> fetchAll([bool force = false]) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(AdminNotification.name)
        .get();
    return snapshot.docs.map((doc) => AdminNotification.doc(doc)).toList();
  }

  /// お知らせを返す
  Future<AdminNotification> fetch(String id) async {
    final doc = await FirebaseFirestore.instance
        .collection(AdminNotification.name)
        .doc(id)
        .get();
    return AdminNotification.doc(doc);
  }

  /// お知らせを追加する
  Future add({
    String? title,
    String? body,
    DateTime? publishDtime,
    bool? publishFlag,
    Uint8List? imageData,
    String? moreLinkURL,
  }) async {
    if (title == null || title.isEmpty) {
      throw ('タイトルを入力してください');
    }
    if (body == null || body.isEmpty) {
      throw ('お知らせ本文を入力してください');
    }

    final newDoc =
        FirebaseFirestore.instance.collection(AdminNotification.name).doc();
    String? imageUrl;

    if (imageData != null) {
      // 画像をアップロードする
      final path = _getNoticeImagePath(newDoc.id);
      imageUrl = await _storage.uploadData(path, imageData);
    }

    // Firestoreに保存する
    await newDoc.set(
      {
        AdminNotificationField.title: title,
        AdminNotificationField.body: body,
        AdminNotificationField.publishDtime: publishDtime,
        AdminNotificationField.publishFlag: publishFlag ?? 0,
        AdminNotificationField.createDtime: Timestamp.now(),
        AdminNotificationField.modifyDtime: Timestamp.now(),
        AdminNotificationField.imageUrl: imageUrl,
        AdminNotificationField.moreLinkURL: moreLinkURL,
      },
    );
  }

  /// お知らせを更新する
  Future update(
    String id, {
    String? title,
    String? body,
    DateTime? publishDtime,
    bool? publishFlag,
    Uint8List? imageData,
    String? moreLinkURL,
  }) async {
    if (title != null && title.isEmpty) {
      throw ('タイトルを入力してください');
    }
    if (body != null && body.isEmpty) {
      throw ('お知らせ本文を入力してください');
    }

    Map<String, dynamic> data = {
      AdminNotificationField.modifyDtime: Timestamp.now(),
    };
    if (title != null) {
      data[AdminNotificationField.title] = title;
    }
    if (body != null) {
      data[AdminNotificationField.body] = body;
    }
    if (publishDtime != null) {
      data[AdminNotificationField.publishDtime] = publishDtime;
    }
    if (publishFlag != null) {
      data[AdminNotificationField.publishFlag] = publishFlag ? 1 : 0;
    }

    // 画像データがあれば画像をアップロードする
    if (imageData != null) {
      // 画像をアップロードする（上書き）
      final path = _getNoticeImagePath(id);
      final imageUrl = await _storage.uploadData(path, imageData);
      data[AdminNotificationField.imageUrl] = imageUrl;
    }

    if (moreLinkURL != null) {
      data[AdminNotificationField.moreLinkURL] = moreLinkURL;
    }

    // Firestoreを更新する
    await FirebaseFirestore.instance
        .collection(AdminNotification.name)
        .doc(id)
        .update(data);
  }

  /// お知らせを削除する
  Future delete(AdminNotification notice) async {
    // Firestoreを削除する
    await FirebaseFirestore.instance
        .collection(AdminNotification.name)
        .doc(notice.id)
        .delete();

    // 画像を削除する
    if (notice.imageUrl.isNotEmpty) {
      final path = _getNoticeImagePath(notice.id);
      await _storage.delete(path);
    }
  }

  /// お知らせ画像のパスを返す
  String _getNoticeImagePath(String id) {
    return '${AdminNotification.name}/$id';
  }
}
