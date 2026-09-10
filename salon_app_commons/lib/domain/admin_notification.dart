import 'package:cloud_firestore/cloud_firestore.dart';

/// お知らせ
class AdminNotification {
  /// コレクション名
  static const name = 'notifications';

  /// ID
  final String id;

  /// お知らせタイトル
  final String title;

  /// お知らせ本文
  final String body;

  /// 公開日時
  final DateTime publishDtime;

  /// 公開フラグ
  final bool publishFlag;

  /// 画像URL
  final String imageUrl;

  /// 作成日時
  final DateTime createDtime;

  /// 更新日時
  final DateTime modifyDtime;

  /// 公開状態
  final NoticePublishState publishState;

  final String moreLinkURL;

  AdminNotification._({
    required this.id,
    required this.title,
    required this.body,
    required this.publishDtime,
    required this.publishFlag,
    required this.imageUrl,
    required this.createDtime,
    required this.modifyDtime,
    required this.publishState,
    required this.moreLinkURL,
  });

  factory AdminNotification.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return AdminNotification._(
      id: doc.id,
      title: data[AdminNotificationField.title],
      body: data[AdminNotificationField.body],
      publishDtime: data[AdminNotificationField.publishDtime]?.toDate(),
      publishFlag: data[AdminNotificationField.publishFlag] == 0,
      imageUrl: data[AdminNotificationField.imageUrl] ?? '',
      createDtime: data[AdminNotificationField.createDtime]?.toDate(),
      modifyDtime: data[AdminNotificationField.modifyDtime]?.toDate(),
      publishState: data[AdminNotificationField.publishFlag] == 0
          ? DateTime.now()
                  .isAfter(data[AdminNotificationField.publishDtime]?.toDate())
              ? NoticePublishState.publishing
              : NoticePublishState.commingSoon
          : NoticePublishState.private,
      moreLinkURL: data[AdminNotificationField.moreLinkURL] ?? '',
    );
  }
}

///公開状態
enum NoticePublishState {
  /// 非公開
  private,

  /// 公開予定
  commingSoon,

  /// 公開中
  publishing,
}

extension NoticePublishStateHelper on NoticePublishState {
  static const labels = {
    NoticePublishState.private: '非公開',
    NoticePublishState.commingSoon: '公開予定',
    NoticePublishState.publishing: '公開中',
  };

  static const tags = {
    NoticePublishState.private: 0,
    NoticePublishState.commingSoon: 1,
    NoticePublishState.publishing: 2,
  };

  String get label => labels[this] ?? '';
  int get tag => tags[this] ?? 0;
}

/// Firestore上の物理名を定義
class AdminNotificationField {
  static const id = 'id';
  static const title = 'title';
  static const body = 'text';
  static const publishDtime = 'date';
  static const publishFlag = 'publishFlg';
  static const imageUrl = 'imageURL';
  static const createDtime = 'createDate';
  static const modifyDtime = 'editDate';
  static const moreLinkURL = 'moreLinkURL';
}
