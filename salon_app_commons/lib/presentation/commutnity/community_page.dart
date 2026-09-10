import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/widget/user_app_widget.dart';
import 'package:transparent_image/transparent_image.dart';

import '../fut_ranking/fut_ranking_page.dart';
import '../github_ranking/github_ranking_page.dart';
import '../member/member_page.dart';
import '../notification_detail/notification_detail_page.dart';
import '../notification_list/notification_list_page.dart';
import '../user_apps/user_apps_page.dart';
import 'community_model.dart';

class CommunityPage extends StatelessWidget {
  static const String route = '/community';

  const CommunityPage({
    super.key,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityModel>(
      create: (_) => CommunityModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Consumer<CommunityModel>(builder: (context, model, child) {
          final notifications = model.notifications;
          final members = model.members;
          final appList = model.appList;
          final futRankingMembers = model.futRankingMembers;

          if (notifications == null || members == null || appList == null || futRankingMembers == null) {
            return const FlutterUnivLoadingIndicator();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  Icons.notifications_sharp,
                  '最新のお知らせ',
                  onPressedMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationListPage(),
                      ),
                    );
                  },
                ),
                const NotificationWidget(),
                if (kIsWeb) const SizedBox(height: 24),
                SectionHeader(
                  Icons.people,
                  '新メンバー',
                  onPressedMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberPage(members: members),
                      ),
                    );
                  },
                ),
                const MemberWidget(),
                if (kIsWeb) const SizedBox(height: 24),
                SectionHeader(
                  Icons.grass,
                  '昨日のGithub草ランキング',
                  onPressedMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GithubRankingPage(model.members!),
                      ),
                    );
                  },
                ),
                const GithubWidget(),
                if (kIsWeb) const SizedBox(height: 24),
                SectionHeader(
                  Icons.monetization_on,
                  '週間FUTランキング',
                  onPressedMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FUTRankingPage(
                          model.members!,
                          model.futTransactions!,
                        ),
                      ),
                    );
                  },
                ),
                const FUTWidget(),
                if (kIsWeb) const SizedBox(height: 24),
                SectionHeader(
                  Icons.apps,
                  '最新リリース',
                  onPressedMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAppsPage(
                          title: 'メンバーのアプリ一覧',
                          appList: appList,
                        ),
                      ),
                    );
                  },
                ),
                AppsWidget(appList: appList),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData iconData;
  final String title;
  final void Function()? onPressedMore;

  const SectionHeader(this.iconData, this.title, {super.key, this.onPressedMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 16, right: 8),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          TextButton(
              onPressed: onPressedMore,
              child: Row(
                children: const [
                  Text(
                    'もっと見る',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<CommunityModel>();
    final notifications = model.notifications!;

    if (notifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '本日の予定はありません',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Column(
      children: notifications
          .map((notification) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetail(notification),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.date!.formatYMDW,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notification.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class MemberWidget extends StatelessWidget {
  const MemberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<CommunityModel>();
    final members = model.members!;
    final slicedMembers = members.length > 10 ? members.sublist(0, 10) : members;

    const noImage = CircleAvatar(
      backgroundColor: themeNavy,
      radius: 40 / 2,
      child: Icon(
        Icons.person,
        size: 40 / 2,
        color: Colors.white,
      ),
    );

    return SizedBox(
      height: 96,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        childAspectRatio: 0.9,
        children: slicedMembers
            .map((member) => InkWell(
                  onTap: () {
                    context.push(MemberDetailPage.route(member.nickname!));
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      member.photoUrl == null
                          ? noImage
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40 / 2),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: member.photoUrl!,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return noImage;
                                    },
                                  )),
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${member.createdAt.getHowLongTimeAgoString(shouldShort: true)}入会',
                        style: const TextStyle(
                          height: 1,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: themeNavy,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        member.nickname ?? '名無し',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        member.prefecture != Prefecture.UNSELECTED ? member.prefecture.nameJpn : '地域未設定',
                        style: const TextStyle(
                          height: 1,
                          fontSize: 9,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class FUTWidget extends StatelessWidget {
  const FUTWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<CommunityModel>();
    final members = model.futRankingMembers!;
    final slicedMembers = members.length > 10 ? members.sublist(0, 10) : members;

    const noImage = CircleAvatar(
      backgroundColor: themeNavy,
      radius: 40 / 2,
      child: Icon(
        Icons.person,
        size: 40 / 2,
        color: Colors.white,
      ),
    );

    return SizedBox(
      height: 96,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        childAspectRatio: 0.9,
        children: slicedMembers
            .map((member) => InkWell(
                  onTap: () {
                    context.push(MemberDetailPage.route(member.nickname!));
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      member.photoUrl == null
                          ? noImage
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40 / 2),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: member.photoUrl!,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return noImage;
                                    },
                                  )),
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${member.coinAmount}',
                            style: const TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeNavy,
                            ),
                          ),
                          const Text(
                            'FUT',
                            style: TextStyle(
                              fontSize: 9,
                              color: themeNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        member.nickname ?? '名無し',
                        style: const TextStyle(
                          height: 1,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class GithubWidget extends StatelessWidget {
  const GithubWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<CommunityModel>();
    final members = model.members!;

    final sortedMembers = [...members].map((e) => e.copyWith(newGithubContribution: e.dailyGithubContribution)).toList()
      ..sort((a, b) => b.githubContribution.compareTo(a.githubContribution));

    final slicedMembers = sortedMembers.length > 10 ? sortedMembers.sublist(0, 10) : sortedMembers;

    const noImage = CircleAvatar(
      backgroundColor: themeNavy,
      radius: 40 / 2,
      child: Icon(
        Icons.person,
        size: 40 / 2,
        color: Colors.white,
      ),
    );

    return SizedBox(
      height: 96,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        childAspectRatio: 0.9,
        children: slicedMembers
            .map((member) => InkWell(
                  onTap: () {
                    context.push(MemberDetailPage.route(member.nickname!));
                  },
                  child: Column(
                    children: [
                      member.photoUrl == null
                          ? noImage
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40 / 2),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: member.photoUrl!,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return noImage;
                                    },
                                  )),
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${member.githubContribution}',
                            style: const TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        member.nickname ?? '名無し',
                        style: const TextStyle(
                          height: 1,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class AppsWidget extends StatelessWidget {
  final List<UserApp> appList;

  const AppsWidget({
    super.key,
    required this.appList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        children: appList.map((app) => UserAppWidget(app)).toList(),
      ),
    );
  }
}

