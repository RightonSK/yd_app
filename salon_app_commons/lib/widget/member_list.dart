import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'member_list_tile.dart';

class MemberList extends StatelessWidget {
  const MemberList(
    this.members,
    this.sortType, {super.key, 
    this.shouldShowRank = false,
  });
  final List<User> members;
  final MemberSortType sortType;
  final bool shouldShowRank;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(
        child: Text('該当メンバーがいません'),
      );
    }

    return ListView.separated(
      itemCount: members.length,
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
        );
      },
      itemBuilder: (context, index) {
        final member = members[index];
        final myUid = UserRepository().myUid;
        final isMe = member.id == myUid;
        return MemberListTile(
          index: index,
          member: member,
          sortType: sortType,
          isMe: isMe,
          shouldShowRank: sortType != MemberSortType.createdAt,
        );
      },
    );
  }
}

enum MemberSortType {
  createdAt,
  point,
  githubContribution;

  static const labels = {
    MemberSortType.createdAt: '入会順',
    MemberSortType.point: 'FUT順',
    MemberSortType.githubContribution: 'Github順',
  };

  String get label => labels[this]!;
}
