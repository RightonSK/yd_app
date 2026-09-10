import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/widget/member_list.dart';
import 'package:transparent_image/transparent_image.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({
    Key? key,
    required this.index,
    required this.member,
    required this.sortType,
    this.shouldShowRank = false,
    this.isMe = false,
  }) : super(key: key);

  final int index;
  final User member;
  final bool shouldShowRank;
  final bool isMe;
  final MemberSortType sortType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isMe ? primaryYellowColor.withOpacity(0.2) : null,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (shouldShowRank)
            SizedBox(
              width: 36,
              child: Text(
                index != -1 ? '${index + 1}位' : '圏外',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          SizedBox(
            width: 50,
            height: 50,
            child: member.photoUrl?.isNotEmpty ?? false
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50 / 2),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: member.photoUrl ?? '',
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return noImage;
                      },
                    ))
                : noImage,
          ),
        ],
      ),
      title: Text(member.nickname ?? 'ニックネーム未設定'),
      subtitle: Text(member.githubUsername ?? ''),
      trailing: trailingTextWidget(member),
      onTap: () async {
        context.push(MemberDetailPage.route(member.nickname!));
      },
    );
  }

  final noImage = const CircleAvatar(
    backgroundColor: themeNavy,
    radius: 50 / 2,
    child: Icon(
      Icons.person,
      size: 50 / 2,
      color: Colors.white,
    ),
  );

  Widget trailingTextWidget(User member) {
    switch (sortType) {
      case MemberSortType.createdAt:
        return Text(
          '${member.createdAt.getHowLongTimeAgoString()}入会',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 11,
          ),
        );
      case MemberSortType.point:
        return Text(
          '${member.coinAmount}FUT',
        );
      case MemberSortType.githubContribution:
        return Text(
          '${member.githubContribution}',
        );
    }
  }
}
