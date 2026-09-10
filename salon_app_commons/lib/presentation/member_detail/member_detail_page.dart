import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/presentation/member_detail/mentor_plan_list.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../widget/profile/profile_header_widget.dart';

Map<String, int> tabStrNumMap = {
  'profile': 0,
  'mentor_plan': 1,
};

Map<int, String> tabNumStrMap = {
  0: 'profile',
  1: 'mentor_plan',
};

class MemberDetailPage extends StatelessWidget {
  static String route(String nickname) {
    return '/users/$nickname';
  }

  const MemberDetailPage({
    super.key,
    this.appBar,
    this.nickname,
    this.userId,
    required this.onTapLinkToMap,
    required this.tabName,
  });

  final String? nickname;
  final String? userId;
  final double photoSize = 80;
  final Future Function(Prefecture prefecture) onTapLinkToMap;
  final PreferredSizeWidget? appBar;
  final String tabName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemberDetailModel>(
      create: (_) => MemberDetailModel(nickname: nickname, userId: userId)..init(),
      child: Scaffold(
        appBar: appBar,
        body: Consumer<MemberDetailModel>(
          builder: (context, model, child) {
            final user = model.user;
            final mentorPlans = model.mentorPlans;

            if (user == null || mentorPlans == null || model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return DefaultTabController(
              initialIndex: tabStrNumMap[tabName] ?? 0,
              animationDuration: Duration.zero,
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                      child: ProfileHeaderWidget(
                        user,
                        settingTapped: model.isMe
                            ? () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyUpdatePage(
                                      appBar: AppBar(),
                                    ),
                                  ),
                                );
                                await model.updateUser();
                              }
                            : null,
                        onTapLinkToMap: onTapLinkToMap,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyTabBarDelegate(
                        tabBar: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          indicatorColor: primaryYellowColor,
                          labelStyle: const BoldMultiLineStyle(fontSize: 14),
                          unselectedLabelStyle: const MultiLineStyle(fontSize: 14),
                          onTap: (int index) {
                            // Retrieve a current query params, tab.
                            String? currentTab = Uri.base.queryParameters["tab"];

                            // Replace the query params in the current URL if the tab param is already set.
                            String replacedURL =
                                URLUtils.getCurrentUrl().replaceFirst(RegExp(r'tab=\w+'), 'tab=${tabNumStrMap[index]}');

                            // If current tab param is not set, add tab param to the replaced URL.
                            if (currentTab == null) {
                              replacedURL += '?tab=${tabNumStrMap[index]}';
                            }

                            URLUtils.changeURLHistory(replacedURL);
                          },
                          tabs: const [
                            Tab(
                              text: 'プロフィール',
                              icon: Icon(
                                Icons.person,
                                size: 20,
                              ),
                            ),
                            Tab(
                              text: 'メンタープラン',
                              icon: Icon(
                                Icons.book,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ProfileDetailWidget(
                      user,
                      apps: model.apps,
                      lectureVideos: model.lectureVideos,
                      presentationVideos: model.presentationVideos,
                      videoHistories: model.videoHistories,
                      clipVideos: model.clipVideos,
                    ),
                    MentorPlanList(
                      user: user,
                      myUid: model.myUid,
                      mentorPlans: mentorPlans,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            color: primaryNavyColor,
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: tabBar,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
