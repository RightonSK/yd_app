import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

//ローディング画面
class LoadingPage extends StatelessWidget {
  static const String route = '/loading';

  const LoadingPage({
    Key? key,
    this.backgroundColor = primaryNavyColor,
  }) : super(key: key);

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
