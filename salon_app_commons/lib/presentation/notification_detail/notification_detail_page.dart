import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationDetail extends StatelessWidget {
  const NotificationDetail(this.notification, {super.key});

  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(notification.title!),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: isMobile ? double.infinity : 600,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: notification.imageURL != null
                      ? FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: notification.imageURL!,
                          fit: BoxFit.contain,
                          imageErrorBuilder: (context, error, stackTrace) {
                            // フィードのエラーハンドリング
                            return Image.asset(
                              'resources/thumbnail1.jpg',
                              fit: BoxFit.contain,
                            );
                          },
                        )
                      : Image.asset(
                          'resources/thumbnail1.jpg',
                          fit: BoxFit.contain,
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        notification.title!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('yyyy/MM/dd').format(notification.date!),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Linkify(
                        onOpen: (link) async {
                          if (await canLaunchUrlString(link.url)) {
                            await launchUrlString(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        text: notification.text!,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      if (notification.moreLinkURL != null &&
                          notification.moreLinkURL!.isNotEmpty)
                        Center(
                          child: RoundedMoveButton(
                            isMobile: isMobile,
                            title: '詳しくはこちら',
                            onTap: () async {
                              final String link;

                              if (notification.moreLinkURL!
                                  .contains('flutteruniv.slack.com')) {
                                // slackだった場合にディープリンクにする
                                // 例
                                // input: https://flutteruniv.slack.com/archives/C014342KVPS
                                // output: 'slack://channel?team=T012UQWDRQC&id=C014342KVPS';
                                final slackId =
                                    notification.moreLinkURL!.split('/').last;
                                final slackDeepLinkURL =
                                    'slack://channel?team=T012UQWDRQC&id=$slackId';
                                link = slackDeepLinkURL;
                              } else {
                                link = notification.moreLinkURL!;
                              }
                              await launchUrlString(link);
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
