import 'package:flutter/foundation.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class FeedModel extends ChangeNotifier {
  FeedModel() {
    _init();
  }
  List<Feed>? feedList;
  bool isLoading = false;

  Future _init() async {
    fetchFeeds();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeeds() async {
    startLoading();
    try {
      feedList = await FeedRepository().fetchFeeds();
      notifyListeners();
    } catch (e) {
      feedList = [];
      logger.d(e);
    } finally {
      endLoading();
    }
  }

  /// フィードが作成された時間を現在時間よりどのくらい前かで取得する
  String getPostingTime(Feed feed) {
    return feed.createdAt.getHowLongTimeAgoString();
  }

  String getTitleText(Feed feed) {
    final nickname =
        (feed.nickname?.isNotEmpty ?? false) ? feed.nickname : '???';
    switch (feed.type) {
      case FeedType.UNKNOWN:
        return 'なにか起きました';
      case FeedType.JOIN_MEMBER:
        return '新メンバーの$nicknameさんが増えました！';
      case FeedType.UPDATE_BIO:
        return '$nicknameさんの自己紹介が更新されました！';
      case FeedType.UPDATE_PHOTO:
        return '$nicknameさんの写真が更新されました！';
      case FeedType.NEWS:
        return feed.title ?? 'お知らせが更新されました';
      case FeedType.VIDEO:
        return feed.title ?? '動画が更新されました';
      case FeedType.FUT:
        return feed.title ?? 'FUT取引が追加されました';
      case FeedType.WEB:
        return feed.title ?? '週刊Flutter大学が追加されました';
      case null:
        return '異常な値です';
    }
  }

  String getSubTitleText(Feed feed) {
    switch (feed.type) {
      case FeedType.UPDATE_BIO:
        return feed.bio ?? '自己紹介文はこちら';
      case FeedType.NEWS:
      case FeedType.VIDEO:
      case FeedType.FUT:
      case FeedType.WEB:
        // 文字数制限
        return _truncateString(feed.description, 200);
      case FeedType.UNKNOWN:
      case FeedType.JOIN_MEMBER:
      case FeedType.UPDATE_PHOTO:
        return '';
      case null:
        return '異常な値です';
    }
  }

  // 文字数がある一定を超えたら...で切る
  String _truncateString(String? data, int length) {
    if (data == null) {
      return '';
    }
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }

  Future deleteFeed(Feed feed) async {
    startLoading();

    try {
      await FeedRepository().delete(feed.feedId!);
      feedList?.removeWhere((f) => f.feedId == feed.feedId);
      notifyListeners();
    } catch (e) {
      logger.d(e);
    } finally {
      endLoading();
    }
  }
}
