import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../user_app_widget.dart';

class AppsGridView extends StatelessWidget {
  final List<UserApp> apps;
  final bool isMyPage;

  const AppsGridView({
    Key? key,
    required this.apps,
    required this.isMyPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> appsWidgets = apps.map((app) {
      return UserAppWidget(app);
    }).toList();
    final List<Widget> widgets = [];
    widgets.addAll(appsWidgets);

    if (isMyPage) {
      widgets.add(const AddAppWidget());
    }
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
            children: const [
              Icon(
                Icons.apps,
                color: Colors.white,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'リリースしたアプリ一覧',
                style: MultiLineStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        if (widgets.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 8,
            ),
            child: Text(
              'まだアプリはありません',
              style: TextStyle(color: Colors.white),
            ),
          ),
        if (widgets.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                childAspectRatio: isMobile ? 2 / 3 : 4 / 5,
                crossAxisCount: isMobile ? 3 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 4,
                children: widgets,
              ),
            ),
          ),
      ],
    );
  }
}
