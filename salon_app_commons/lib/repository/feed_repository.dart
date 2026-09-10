import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/extensions/list_extension.dart';

import '../domain/feed.dart';

/// フィード関連の操作をまとめたクラス (Singleton)
class FeedRepository {
  static FeedRepository? _instance;
  FeedRepository._internal();

  factory FeedRepository() {
    return _instance ??= FeedRepository._internal();
  }

  /// フィードをすべて取得する
  Future<List<Feed>?> fetchFeeds() async {
    final collection = FirebaseFirestore.instance.collection('feeds');
    final feeds =
        await collection.orderBy(FeedField.createdAt, descending: true).get();

    final originalFeeds = feeds.docs.map((e) => Feed.doc(e)).toList();
    return _summarizeFeed(originalFeeds);
  }

  /// 新メンバーのフィードを取得する
  Future<List<Feed>?> fetchNewMemberFeeds() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('feeds')
        .where('type', isEqualTo: 'JOIN_MEMBER')
        .orderBy(FeedField.createdAt, descending: true)
        .limit(10)
        .get();
    final feeds = snapshot.docs.map((e) => Feed.doc(e)).toList();
    return feeds;
  }

  // 同じ種類だったらまとめる
  List<Feed> _summarizeFeed(List<Feed> originalFeeds) {
    List<Feed> summarizedFeeds = [];
    List<Feed> consecutiveFutFeeds = [];
    Feed? previousFeed;
    for (int i = 0; i < originalFeeds.length + 1; i++) {
      final Feed? currentFeed = originalFeeds.elementAtSafely(i);

      if (previousFeed != null) {
        if (previousFeed.type == FeedType.FUT &&
            currentFeed?.type == FeedType.FUT) {
          // 前も今回もFUTタイプだったらインクリメント
          consecutiveFutFeeds.add(previousFeed);
        } else if (consecutiveFutFeeds.isNotEmpty &&
            previousFeed.type == FeedType.FUT) {
          // まとめの終わり
          final firstFeed = consecutiveFutFeeds.first;
          final groupedFeed = Feed(
            '',
            firstFeed.userId,
            firstFeed.type,
            firstFeed.nickname,
            firstFeed.githubUsername,
            firstFeed.photoUrl,
            firstFeed.bio,
            firstFeed.createdAt,
            'FUT取引(複数人)',
            '${firstFeed.description}ほか${consecutiveFutFeeds.length}名。',
            firstFeed.url,
          );
          summarizedFeeds.add(groupedFeed);
          consecutiveFutFeeds = [];
        } else {
          // まとめに追加
          summarizedFeeds.add(previousFeed);
          consecutiveFutFeeds = [];
        }
      }
      previousFeed = currentFeed;
    }
    return summarizedFeeds;
  }

  Future delete(String feedId) {
    final collection = FirebaseFirestore.instance.collection('feeds');
    return collection.doc(feedId).delete();
  }
}
