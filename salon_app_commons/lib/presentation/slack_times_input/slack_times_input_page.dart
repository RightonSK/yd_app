import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class SlackTimesInputPage extends StatelessWidget {
  static const String route = '/slack_times_input';

  final PreferredSizeWidget appBar;

  const SlackTimesInputPage({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavyColor,
      appBar: appBar,
      body: SlackTimesInputBody(
        onCompleteInputTimes: () async {
          context.push(MyFUTPage.route);
        },
      ),
    );
  }
}
