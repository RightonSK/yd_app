import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feed {
  final String? feedId;
  final String? userId;
  final FeedType? type;
  final String? nickname;
  final String? githubUsername;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final String? title;
  final String? description;
  final String? url;

  Feed(
    this.feedId,
    this.userId,
    this.type,
    this.nickname,
    this.githubUsername,
    this.photoUrl,
    this.bio,
    this.createdAt,
    this.title,
    this.description,
    this.url,
  );

  factory Feed.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return Feed(
      doc.id,
      data[FeedField.userId],
      FeedType.from(data[FeedField.type]),
      data[FeedField.nickname],
      data[FeedField.githubUsername],
      data[FeedField.photoUrl],
      data[FeedField.bio],
      _toDate(data, FeedField.createdAt),
      data[FeedField.title],
      data[FeedField.description],
      data[FeedField.url],
    );
  }

  /// Timestamp => DateTime
  static DateTime _toDate(Map data, String fieldName) {
    if (data[fieldName] is Timestamp) {
      return (data[fieldName] as Timestamp).toDate();
    }
    return DateTime.now();
  }

  bool isMyFeed() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return userId == currentUser?.uid;
  }
}

class FeedField {
  static const feedId = 'feedId';
  static const userId = 'userId';
  static const type = 'type';
  static const nickname = 'nickname';
  static const githubUsername = 'github_username';
  static const photoUrl = 'photoUrl';
  static const bio = 'bio';
  static const createdAt = 'createdAt';
  static const title = 'title';
  static const description = 'description';
  static const url = 'url';
}

enum FeedType {
  UNKNOWN,
  JOIN_MEMBER,
  UPDATE_BIO,
  UPDATE_PHOTO,
  NEWS,
  VIDEO,
  FUT,
  WEB;

  String get value => toString().split('.').last;

  /// 文字列からenumを生成する
  ///
  /// 引数がenumのドット以降とマッチしない場合はUNKNOWNを返す
  ///
  /// [value]: 'JOINT_MEMBER', 'UPDATE_BIO' ...
  static FeedType from(String value) =>
      FeedType.values.firstWhere((e) => e.value == value, orElse: () => FeedType.UNKNOWN);
}

const kFeedDefaultImageURL =
    'https://firebasestorage.googleapis.com/v0/b/kboy-salon-app-prod.appspot.com/o/flutterdaigaku_thumbnail.jpg?alt=media&token=fbbb4738-3c41-4735-9fe0-92f683855464';
