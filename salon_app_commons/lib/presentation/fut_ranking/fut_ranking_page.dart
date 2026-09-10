import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../widget/member_list.dart';
import '../../widget/my_rank_member_list_tile.dart';
import 'fut_ranking_model.dart';

class FUTRankingPage extends StatefulWidget {
  const FUTRankingPage(this.members, this.futTransactions, {super.key});

  final List<User> members;
  final List<FUTTransaction> futTransactions;

  @override
  State<FUTRankingPage> createState() => _FUTRankingPageState();
}

class _FUTRankingPageState extends State<FUTRankingPage>
    with SingleTickerProviderStateMixin {
  final tabs = [
    const Tab(text: '日間'),
    const Tab(text: '週間'),
    const Tab(text: '月間'),
    const Tab(text: '累計'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FUTRankingModel>(
      create: (_) => FUTRankingModel(
        this,
        tabs.length,
        widget.members,
        widget.futTransactions,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('獲得FUTランキング'),
          actions: [
            TextButton(
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () async {
                context.push(MyFUTPage.route);
              },
            ),
          ],
        ),
        body: Consumer<FUTRankingModel>(
          builder: (context, model, child) {
            final myUser = model.myUser;
            return Column(
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
                              MemberSortType.point,
                              shouldShowRank: true,
                            ))
                        .toList(),
                  ),
                ),
                if (myUser != null)
                  MyRankMemberListTile(
                    myIndex: model.myIndex ?? -1,
                    myUser: myUser,
                    sortType: MemberSortType.point,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
