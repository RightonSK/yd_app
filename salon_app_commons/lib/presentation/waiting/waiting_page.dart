import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class WaitingPage extends StatelessWidget {
  static const String route = '/waiting';

  const WaitingPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const LoadingPage(),
    );
  }
}
