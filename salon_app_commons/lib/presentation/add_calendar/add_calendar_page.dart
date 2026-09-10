import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// ログイン
class AddCalendarPage extends StatelessWidget {
  static const String route = '/add_calendar';

  final PreferredSizeWidget appBar;
  final void Function(BuildContext context) onTapNextPage;

  const AddCalendarPage(
      {Key? key, required this.appBar, required this.onTapNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            const NewUserInputIndicator(5),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Flutter大学のGoogleカレンダーを追加して\n予定を見逃さないようにしましょう！',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: 360,
              child: LinkCard(
                isLight: true,
                isMobile: false,
                title: 'Googleカレンダーに追加',
                onTap: () async {
                  await URLUtils.launch(
                    urlString:
                        'https://calendar.google.com/calendar/u/0?cid=NGl1cG5jNTJtNnRuYWdmMW44YTNxOHV2bnNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ',
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                onTapNextPage(context);
              },
              child: Text(
                '次へ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryYellowColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
