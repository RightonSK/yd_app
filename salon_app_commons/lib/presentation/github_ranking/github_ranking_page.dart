import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../widget/member_list.dart';
import '../../widget/my_rank_member_list_tile.dart';
import 'github_ranking_model.dart';

class GithubRankingPage extends StatefulWidget {
  const GithubRankingPage(this.members, {super.key});
  final List<User> members;

  @override
  State<GithubRankingPage> createState() => _GithubRankingPageState();
}

class _GithubRankingPageState extends State<GithubRankingPage>
    with SingleTickerProviderStateMixin {
  final tabs = [
    const Tab(text: '日間'),
    const Tab(text: '週間'),
    const Tab(text: '月間'),
    const Tab(text: '年間'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GithubRankingModel>(
      create: (_) => GithubRankingModel(
        this,
        tabs.length,
        widget.members,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Github草ランキング'),
        ),
        body: Consumer<GithubRankingModel>(
          builder: (context, model, child) {
            final myUser = model.myUser;
            return Stack(
              children: [
                Column(
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: TabBar(
                        controller: model.tabController,
                        labelColor: themeNavy,
                        tabs: tabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: model.tabController,
                        children: model.rankings
                            .map((ranking) => MemberList(
                                  ranking,
                                  MemberSortType.githubContribution,
                                  shouldShowRank: true,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                if (myUser != null)
                  MyRankMemberListTile(
                    myIndex: model.myIndex ?? -1,
                    myUser: myUser,
                    sortType: MemberSortType.githubContribution,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
