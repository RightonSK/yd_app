import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

class MembersSearchPage extends StatelessWidget {
  const MembersSearchPage({super.key, this.shouldShowMyself = false});

  final bool shouldShowMyself;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MembersSearchModel>(
      create: (_) => MembersSearchModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("メンバー検索"),
        ),
        backgroundColor: primaryNavyColor,
        body: SafeArea(
          child: Consumer<MembersSearchModel>(builder: (context, model, child) {
            final members =
                shouldShowMyself ? model.allMembers : model.otherMembers;
            if (members == null) {
              return const FlutterUnivLoadingIndicator(
                backgroundColor: primaryNavyColor,
              );
            }
            final searchedMembers = model.searchMemberByName(
              searchWord: model.userSearchController.text,
              members: members,
            );

            return Column(
              children: [
                Expanded(
                  child: _MemberList(
                    members: searchedMembers,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'メンバーを検索',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: primaryNavyColor,
                        ),

                        /// 検索ワードをクリアするボタン
                        suffixIcon: model.userSearchController.text.isNotEmpty
                            ? InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                onTap: model.userSearchController.clear,
                                child: Container(
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.clear_rounded,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      controller: model.userSearchController,
                      autofocus: true,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.members,
  });

  final List<User> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(
        child: Text(
          '該当メンバーがいません',
          style: TextStyle(color: Colors.white),
        ),
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
        const noImage = CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50 / 2,
          child: Icon(
            Icons.person,
            size: 50 / 2,
            color: primaryNavyColor,
          ),
        );
        return ListTile(
          tileColor: isMe ? primaryYellowColor.withOpacity(0.2) : null,
          leading: SizedBox(
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
          title: Text(
            member.nickname ?? 'ニックネーム未設定',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            member.githubUsername ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Text(
            '${member.coinAmount}FUT',
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () async {
            // メンバーを前の画面に返す
            Navigator.of(context).pop(member);
          },
        );
      },
    );
  }
}
