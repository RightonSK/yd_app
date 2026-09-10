import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

import '../notification_detail/notification_detail_page.dart';
import 'notification_list_model.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('お知らせ一覧'),
      ),
      body: ChangeNotifierProvider<NotificationListModel>(
        create: (_) => NotificationListModel()..fetchNotifications(),
        child:
            Consumer<NotificationListModel>(builder: (context, model, child) {
          return model.isLoading
              ? const FlutterUnivLoadingIndicator()
              : model.notifications.isNotEmpty
                  ? _notificationList(
                      context,
                      model.notifications,
                      child,
                    )
                  : const Text('該当するお知らせはありません');
        }),
      ),
    );
  }

  Widget _notificationList(
      BuildContext context, List<NotificationData> notifications, child) {
    notifications.sort((a, b) => b.date!.compareTo(a.date!));
    final List<Widget> notificationList = notifications.asMap().entries.map(
      (entry) {
        final int index = entry.key;
        final notification = entry.value;

        // 一番上だけでかい
        if (index == 0) {
          return InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetail(notification),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: notification.imageURL != null
                      ? FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: notification.imageURL!,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            // フィードのエラーハンドリング
                            return Image.asset(
                              'resources/thumbnail1.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'resources/thumbnail1.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          notification.title!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd').format(notification.date!),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return ListTile(
          leading: SizedBox(
            width: 80,
            child: notification.imageURL != null
                ? FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: notification.imageURL!,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      // フィードのエラーハンドリング
                      return Image.asset(
                        'resources/thumbnail1.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'resources/thumbnail1.jpg',
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(notification.title!),
          subtitle: Text(
            DateFormat('yyyy/MM/dd').format(notification.date!),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationDetail(notification),
              ),
            );
          },
        );
      },
    ).toList();
    return ListView.separated(
      itemCount: notificationList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return notificationList[index];
      },
    );
  }
}
