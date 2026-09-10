import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class NewUsersWidget extends StatelessWidget {
  const NewUsersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = context.watch<LPModel>().isMobile;
    final model = context.read<LPModel>();
    return CarouselSlider(
      options: CarouselOptions(
        autoPlayInterval: const Duration(seconds: 3),
        height: 40,
        autoPlay: true,
        enableInfiniteScroll: true,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
      items: model.recentUsersFeeds!.map((feed) {
        return Column(
          children: [
            const SizedBox(height: 16),
            Text(
              '${feed.createdAt.getHowLongTimeAgoString()}${t.newMembers.ni}${createAnonymousNickName(feed.nickname)}${t.newMembers.joined}',
              style: BoldMultiLineStyle(
                color: primaryYellowColor,
                fontSize: isMobile? 8 : 15,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String createAnonymousNickName(String? nickname) {
    if (nickname == null) {
      return '';
    }

    if (nickname.length < 2) {
      return '*';
    }
    return nickname[0] + '*' * (nickname.length - 1);
  }
}
