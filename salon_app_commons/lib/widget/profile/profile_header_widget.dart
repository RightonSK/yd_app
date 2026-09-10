import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHeaderWidget extends StatelessWidget {
  static const double photoSize = 72;
  final User user;
  final void Function()? settingTapped;
  final Future Function(Prefecture prefecture) onTapLinkToMap;

  const ProfileHeaderWidget(
    this.user, {
    Key? key,
    required this.settingTapped,
    required this.onTapLinkToMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const noImage = CircleAvatar(
      backgroundColor: themeNavy,
      radius: photoSize / 2,
      child: Icon(
        Icons.person,
        size: photoSize / 2,
        color: Colors.white,
      ),
    );

    final bool isMyPage = settingTapped != null;
    final bool isMyPageAndNoBio = isMyPage && user.bio == null;
    final bool isMyPageAndNoSlackTimes = isMyPage && user.slackTimesId == null;
    final bool isMyPageAndPrefectureUnselected = isMyPage && user.prefecture == Prefecture.UNSELECTED;

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              height: photoSize,
                              width: photoSize,
                              child: user.photoUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(photoSize / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: user.photoUrl!,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.nickname ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'URLをコピー',
                                        child: IconButton(
                                          onPressed: () async {
                                            String url = '${URLUtils.getBaseUrl()}/users/${user.nickname}';
                                            await Clipboard.setData(ClipboardData(text: url));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('URLをクリップボードにコピーしました！'),
                                                backgroundColor: primaryYellowColor,
                                              ),
                                            );
                                            if (!kIsWeb) {
                                              await Future.delayed(
                                                const Duration(milliseconds: 200),
                                              );
                                              HapticFeedback.mediumImpact();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.share,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  if (isMyPage)
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: settingTapped,
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.black54,
                                          ),
                                        ),
                                        child: const Text(
                                          'プロフィール編集',
                                          style: MultiLineStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: isMyPageAndNoBio ? settingTapped : null,
                      child: Linkify(
                        text: user.bio ?? '自己紹介未記入',
                        style: isMyPageAndNoBio
                            ? const TextStyle(
                                color: primaryNavyColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              )
                            : null,
                        onOpen: (link) async {
                          final url = Uri.parse(link.url);
                          await launchUrl(url);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: '継続日数に応じて色が変わります！',
                        child: Icon(
                          Icons.timelapse,
                          color: UserBadge.getContinueBadge(user.createdAt)?.color,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        child: Text(
                          '${user.createdAt.getHowLongTimeAgoString()}に入会',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesome5.slack,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        child: Text(user.slackTimesId != null ? 'times登録済み' : 'times未設定',
                            style: isMyPageAndNoSlackTimes
                                ? const TextStyle(
                                    color: primaryNavyColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  )
                                : const TextStyle(
                                    color: primaryNavyColor,
                                  )),
                        onTap: () async {
                          if (user.slackTimesId != null) {
                            final url = 'slack://channel?team=T012UQWDRQC&id=${user.slackTimesId}';
                            URLUtils.launch(urlString: url, shouldOpenNewTab: true);
                          } else if (isMyPageAndNoSlackTimes) {
                            context.push(SlackTimesInputPage.route);

                            // FIXME: 本当は帰ってきてからリロードしたいが、go_routerに変えて、awaitできないので一旦諦めてる
                            // await context.read<MyModel>().init();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Image.asset(
                          'resources/github.png',
                          width: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        onTap: user.githubUsername != null
                            ? () async {
                                final url = 'https://github.com/${user.githubUsername}';
                                URLUtils.launch(urlString: url, shouldOpenNewTab: true);
                              }
                            : null,
                        child: Text(
                          user.githubUsername != null ? "${user.githubUsername!} (${user.githubContribution})" : '未設定',
                          style: user.githubUsername != null ? const TextStyle(color: primaryNavyColor) : null,
                        ),
                      ),
                      const Tooltip(
                        message: 'GitHub過去1年間のContributions',
                        child: Icon(
                          Icons.info,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Image.asset(
                          'salon_app_commons/resources/zenn.png',
                          width: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (user.zennId != null) {
                                final url = 'https://zenn.dev/${user.zennId}';
                                URLUtils.launch(urlString: url, shouldOpenNewTab: true);
                              } else if (isMyPage) {
                                context.push(ZennInputPage.route);
                              }
                            },
                            child: Text(
                              user.zennId != null ? user.zennId! : '未設定',
                              style: user.zennId != null ? const TextStyle(color: primaryNavyColor) : null,
                            ),
                          ),
                          if (isMyPage) const SizedBox(width: 4),
                          if (isMyPage)
                            InkWell(
                              onTap: () {
                                context.push(ZennInputPage.route);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        onTap: user.prefecture != Prefecture.UNSELECTED
                            ? () async {
                                await onTapLinkToMap(user.prefecture);
                              }
                            : settingTapped,
                        child: Text(user.prefecture.nameJpn,
                            style: isMyPageAndPrefectureUnselected
                                ? const TextStyle(
                                    color: primaryNavyColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  )
                                : const TextStyle(
                                    color: primaryNavyColor,
                                  )), // myPageだったら設定へ
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        child: Text(
                          '${user.coinAmount} FUT',
                          style: const TextStyle(color: primaryNavyColor),
                        ),
                        onTap: () async {
                          context.push(MyFUTPage.route);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
