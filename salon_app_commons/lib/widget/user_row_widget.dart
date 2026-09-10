import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

class UserRowWidget extends StatelessWidget {
  final User user;
  const UserRowWidget(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    const noImage = CircleAvatar(
      backgroundColor: primaryNavyColor,
      radius: 24 / 2,
      child: Icon(
        Icons.person,
        size: 24 / 2,
        color: Colors.white,
      ),
    );
    return InkWell(
      onTap: () {
        context.push(MemberDetailPage.route(user.nickname!));
      },
      child: Row(
        children: [
          user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24 / 2),
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
              : noImage,
          const SizedBox(
            width: 8,
          ),
          Text(
            user.nickname ?? '不明',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
