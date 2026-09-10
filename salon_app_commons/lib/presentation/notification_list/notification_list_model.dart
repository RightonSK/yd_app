import 'package:flutter/material.dart';
import 'package:salon_app_commons/domain/notification.dart';
import 'package:salon_app_commons/repository/notification_repository.dart';

class NotificationListModel extends ChangeNotifier {
  bool isLoading = true;
  List<NotificationData> notifications = [];

  final _notificationRepo = NotificationRepository();

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future fetchNotifications() async {
    notifications = await _notificationRepo.fetchAll();
    endLoading();
  }
}
