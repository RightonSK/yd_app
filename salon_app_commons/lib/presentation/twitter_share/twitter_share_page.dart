import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class TwitterSharePage extends StatelessWidget {
  static const String route = '/twitter_share';

  final String? planName;
  final PreferredSizeWidget appBar;

  const TwitterSharePage(this.planName, {Key? key, required this.appBar})
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
            const NewUserInputIndicator(4),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Flutter大学に入学したことを\nTwitterでシェアしよう！',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              '(公式アカウントでリツイートさせていただきます)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: 300,
              child: LinkCard(
                title: 'Twitterでシェア',
                isLight: true,
                isMobile: false,
                onTap: () {
                  const twitterURL = 'https://twitter.com/intent/tweet?text=';
                  final String url;
                  if (planName != null) {
                    url =
                        '${twitterURL}Flutter大学の$planNameに入学しました！&hashtags=Flutter大学&url=https://flutteruniv.com';
                  } else {
                    url =
                        '${twitterURL}Flutter大学に入学しました！&hashtags=Flutter大学&url=https://flutteruniv.com';
                  }
                  URLUtils.launch(urlString: url);
                  AnalyticsUtils.sendLog(AnalyticsEvent.btnShareTwitter);
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () async {
                context.go(AddCalendarPage.route);
              },
              child: Text(
                '次へ進む',
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
