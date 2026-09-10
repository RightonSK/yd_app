import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/widget/member_list.dart';

import 'member_list_tile.dart';

class MyRankMemberListTile extends StatelessWidget {
  const MyRankMemberListTile({
    Key? key,
    required this.myIndex,
    required this.myUser,
    required this.sortType,
  }) : super(key: key);

  final int myIndex;
  final User myUser;
  final MemberSortType sortType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 20,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                      ),
                      child: Text('👑あなたの順位'),
                    ),
                    MemberListTile(
                      index: myIndex,
                      member: myUser,
                      sortType: sortType,
                      shouldShowRank: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
