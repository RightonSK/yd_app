import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

class MultiUserRowWidget extends StatelessWidget {
  final List<User> users;
  const MultiUserRowWidget(this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: users.map((user) {
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: InkWell(
                onTap: () {
                  context.push(MemberDetailPage.route(user.nickname!));
                },
                child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20 / 2),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: user.photoUrl!,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              // フィードのエラーハンドリング
                              return noImage;
                            },
                          ),
                        ),
                      )
                    : noImage),
          );
        }).toList(),
      ),
    );
  }

  final noImage = const CircleAvatar(
    backgroundColor: primaryNavyColor,
    radius: 20 / 2,
    child: Icon(
      Icons.person,
      size: 20 / 2,
      color: Colors.white,
    ),
  );
}
