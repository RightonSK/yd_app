import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/widget/user_app_widget.dart';

class UserAppsPage extends StatelessWidget {
  final String title;
  final List<UserApp> appList;

  const UserAppsPage({
    super.key,
    required this.title,
    required this.appList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        children: appList.map((app) => UserAppWidget(app)).toList(),
      ),
    );
  }
}
