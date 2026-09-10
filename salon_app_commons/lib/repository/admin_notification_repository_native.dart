import 'dart:typed_data';

import '../domain/admin_notification.dart';

class AdminNotificationRepository {
  /// お知らせ一覧を返す
  Future fetchAll([bool force = false]) async {}

  /// お知らせを返す
  Future fetch(String id) async {}

  /// お知らせを追加する
  Future add({
    String? title,
    String? body,
    DateTime? publishDtime,
    bool? publishFlag,
    Uint8List? imageData,
    String? moreLinkURL,
  }) async {}

  /// お知らせを更新する
  Future update(
    String id, {
    String? title,
    String? body,
    DateTime? publishDtime,
    bool? publishFlag,
    Uint8List? imageData,
    String? moreLinkURL,
  }) async {}

  /// お知らせを削除する
  Future delete(AdminNotification notice) async {}
}
