import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class InvitePage extends StatelessWidget {
  static const String route = '/invite';
  final PreferredSizeWidget appBar;
  const InvitePage({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavyColor,
      appBar: appBar,
      body: const InviteBody(),
    );
  }
}
