import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class UserBadgeWidget extends StatelessWidget {
  final UserBadge badge;
  final bool has;
  const UserBadgeWidget(this.badge, this.has, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Icon(
              badge.icon,
              color: has ? badge.color : Colors.black12,
              size: 40,
            ),
          ),
          SizedBox(
            height: 28,
            child: Text(
              badge.nameJP,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: has ? badge.color : Colors.black26,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
