import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

import '../github_ranking/github_ranking_page.dart';
import '../notification_detail/notification_detail_page.dart';
import 'feed_model.dart';

class FeedPage extends StatelessWidget {
  static const String route = '/feed';

  const FeedPage({
    super.key,
    this.appBar,
    required this.googleToken,
    required this.calendarId,
  });
  final PreferredSizeWidget? appBar;
  final String googleToken;
  final String calendarId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<FeedModel>(create: (_) => FeedModel()),
          ChangeNotifierProvider<CalendarModel>(
              create: (_) => CalendarModel(googleToken, calendarId)..init()),
        ],
        child: Consumer2<FeedModel, CalendarModel>(
          builder: (context, feedModel, calendarModel, child) {
            final feedList = feedModel.feedList;

            final now = DateTime.now();
            final todayString = DateFormat('M月d日').format(now);
            final todayEvents = calendarModel.todayEvents;

            final dateFormatForDayOfWeek = DateFormat.E('ja');
            final formatStrForDayOfWeek = dateFormatForDayOfWeek.format(now);
            int itemCount = feedModel.feedList?.length ?? 0;

            if (todayEvents != null && todayEvents.isNotEmpty) {
              itemCount += 1;
            }

            if (feedList == null || todayEvents == null) {
              return const FlutterUnivLoadingIndicator();
            }

            return RefreshIndicator(
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                await calendarModel.init();
                await feedModel.fetchFeeds();
                HapticFeedback.mediumImpact();
              },
              child: (feedList.isNotEmpty)
                  ? ListView.separated(
                      itemCount: itemCount,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 2,
                      ),
                      itemBuilder: (context, index) {
                        // スケジュールのwidget
                        if (index == 0 && todayEvents.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                Icons.today,
                                '$todayString ($formatStrForDayOfWeek)',
                                onPressedMore: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CalendarPage(
                                        appBar: AppBar(
                                          title: const Text('スケジュール'),
                                        ),
                                        googleToken: googleToken,
                                        calendarId: calendarId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: todayEvents
                                      .map(
                                        (event) => CalendarItemWidget(
                                          item: event,
                                          isFeed: true,
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            ],
                          );
                        }
                        final feed =
                            feedModel.feedList?.elementAtSafely(index - 1);

                        if (feed == null) {
                          return const SizedBox();
                        }

                        return InkWell(
                          onTap: () async {
                            if (feed.nickname != null) {
                              context
                                  .push(MemberDetailPage.route(feed.nickname!));
                            } else if (feed.type == FeedType.NEWS) {
                              if (feed.title == '昨日のGitHubランキング') {
                                // FIXME: feed.type == GitHubを作った方がいいかも
                                final members =
                                    await UserRepository().fetchMembers();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GithubRankingPage(members),
                                  ),
                                );
                              } else {
                                final notification = NotificationData(
                                  title: feed.title,
                                  text: feed.description,
                                  date: feed.createdAt,
                                  imageURL: feed.photoUrl,
                                  moreLinkURL: feed.url,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetail(notification),
                                  ),
                                );
                              }
                            } else if (feed.type == FeedType.VIDEO) {
                              // 動画への遷移
                              final url = feed.url;
                              final urlPaths = url?.split('/');
                              final category = urlPaths?.elementAtSafely(4);
                              final videoId = urlPaths?.elementAtSafely(5);

                              if (category != null && videoId != null) {
                                context.push(
                                    VideoDetailPage.route(category, videoId));
                              }
                            } else if (feed.type == FeedType.FUT) {
                              context.push(MyFUTPage.route);
                            } else if (feed.type == FeedType.WEB) {
                              if (feed.url != null) {
                                URLUtils.launch(
                                  urlString: feed.url!,
                                  shouldOpenNewTab:
                                      feed.url!.contains('youtube'),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedModel.getPostingTime(feed),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                ContentWidget(
                                  context: context,
                                  model: feedModel,
                                  feed: feed,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Text('タイムライン情報はありません'),
            );
          },
        ),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.context,
    required this.model,
    required this.feed,
  });

  final BuildContext context;
  final FeedModel model;
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    switch (feed.type) {
      case FeedType.UNKNOWN:
      case FeedType.JOIN_MEMBER:
      case FeedType.UPDATE_BIO:
      case FeedType.UPDATE_PHOTO:
      case FeedType.FUT:
        return DefaultListTile(context: context, model: model, feed: feed);
      case FeedType.NEWS:
      case FeedType.WEB:
      case FeedType.VIDEO:
        return NewsWidget(context: context, model: model, feed: feed);
      case null:
        return const SizedBox();
    }
  }
}

class DefaultListTile extends StatelessWidget {
  const DefaultListTile({
    super.key,
    required this.context,
    required this.model,
    required this.feed,
  });

  final BuildContext context;
  final FeedModel model;
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserPhoto(feed: feed),
      title: Text(
        model.getTitleText(feed),
      ),
      subtitle: Text(
        model.getSubTitleText(feed),
      ),
      trailing: TrashWidget(context: context, model: model, feed: feed),
    );
  }
}

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    super.key,
    required this.context,
    required this.model,
    required this.feed,
  });

  final BuildContext context;
  final FeedModel model;
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    final imageWidget = AspectRatio(
      aspectRatio: 16 / 9,
      child: feed.photoUrl != null && feed.photoUrl != kFeedDefaultImageURL
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: feed.photoUrl!,
              fit:
                  feed.description == 'YouTube' ? BoxFit.cover : BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) {
                // フィードのエラーハンドリング
                return Image.asset(
                  'salon_app_commons/resources/blog_thumbnail.png',
                  fit: BoxFit.contain,
                );
              },
            )
          : Image.asset(
              'salon_app_commons/resources/blog_thumbnail.png',
              fit: BoxFit.contain,
            ),
    );

    final titleWidget = Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!feed.description!.contains('Zenn') || kIsWeb)
            Text(
              feed.title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            feed.description!,
            maxLines: 10,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );

    return kIsWeb
        ? SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                const SizedBox(width: 8),
                Expanded(
                  child: titleWidget,
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: imageWidget,
              ),
              titleWidget,
            ],
          );
  }
}

class UserPhoto extends StatelessWidget {
  const UserPhoto({
    super.key,
    required this.feed,
  });

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    const photoSize = 50.0;
    final bool photoAvailable = feed.photoUrl?.isNotEmpty ?? false;

    const noImage = CircleAvatar(
      backgroundColor: themeNavy,
      radius: photoSize / 2,
      child: Icon(
        Icons.person,
        size: photoSize / 2,
        color: Colors.white,
      ),
    );

    return SizedBox(
      width: photoSize,
      height: photoSize,
      child: photoAvailable
          ? ClipRRect(
              borderRadius: BorderRadius.circular(photoSize / 2),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: feed.photoUrl!,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  // フィードのエラーハンドリング
                  return noImage;
                },
              ),
            )
          : noImage,
    );
  }
}

class TrashWidget extends StatelessWidget {
  const TrashWidget({
    super.key,
    required this.context,
    required this.model,
    required this.feed,
  });

  final BuildContext context;
  final FeedModel model;
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return feed.isMyFeed()
        ? SizedBox(
            width: 40,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // 削除する
                  final isYes = await showConfirmDialog(
                    context,
                    '削除しますか？',
                  );
                  if (isYes) {
                    await model.deleteFeed(feed);
                  }
                },
              ),
            ),
          )
        : const SizedBox();
  }
}
