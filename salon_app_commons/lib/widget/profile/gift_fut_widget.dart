import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GiftFUTWidget extends StatelessWidget {
  final User user;

  const GiftFUTWidget(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: SizedBox(
        height: 60,
        width: 300,
        child: RoundedMoveButton(
          backgroundColor: Colors.white,
          textColor: primaryNavyColor,
          isMobile: true,
          title: 'FUTをギフトする',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftFUTPage(
                  toUser: user,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
