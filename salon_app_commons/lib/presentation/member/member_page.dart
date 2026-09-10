import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../widget/member_list.dart';
import 'member_model.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key, this.members});
  final List<User>? members;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemberModel>(
      create: (_) => MemberModel(members: members),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('メンバー'),
          actions: [
            Consumer<MemberModel>(builder: (context, model, child) {
              return IconButton(
                icon: const Icon(
                  Icons.person_pin_circle_rounded,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembersMapPage(
                        members: model.members,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
        body: Stack(
          children: [
            Consumer<MemberModel>(
              builder: (context, model, child) {
                final members = model.members;

                if (members == null) {
                  return const FlutterUnivLoadingIndicator();
                }

                if (members.isEmpty) {
                  return const Center(child: Text('メンバーは０人です'));
                }

                return MemberList(
                  members,
                  model.currentSortType,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
