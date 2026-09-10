import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class BadgeListWidget extends StatelessWidget {
  final User user;
  final List<UserBadge> havingBadges;

  const BadgeListWidget(
    this.user, {
    Key? key,
    required this.havingBadges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.expand_circle_down_outlined,
                color: Colors.white,
              ),
              const SizedBox(
                width: 4,
              ),
              const Text(
                '取得したバッジ',
                style: MultiLineStyle(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.push(BadgeListPage.route, extra: user.badges);
                },
                child: Row(
                  children: const [
                    Text(
                      'もっとみる',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: havingBadges.isEmpty
                ? const Center(
                    child: Text(
                    'まだバッジはありません',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ))
                : GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: isMobile ? 2 / 3 : 1,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 6,
                    crossAxisSpacing: 4,
                    children: user.badges.map((badge) {
                      return UserBadgeWidget(badge, true);
                    }).toList(),
                  ),
          ),
        )
      ],
    );
  }
}
