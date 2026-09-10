import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'badge_list_model.dart';

class BadgeListPage extends StatelessWidget {
  static const route = '/badge_list';

  final PreferredSizeWidget appBar;
  final List<UserBadge>? badges;

  const BadgeListPage({
    super.key,
    this.badges,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BadgeListModel>(
      create: (_) => BadgeListModel(badges: badges),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Consumer<BadgeListModel>(builder: (context, model, child) {
          const allBadges = UserBadge.values;
          final havingBadges = model.badges;

          if (havingBadges == null) {
            return const FlutterUnivLoadingIndicator();
          }
          return GridView.count(
            crossAxisCount: isMobile ? 3 : 10,
            children: allBadges
                .map(
                  (badge) => UserBadgeWidget(
                    badge,
                    havingBadges.contains(badge),
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
