import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/notification.dart';

class NotificationRepository {
  /// limitの数だけ取る
  Future<List<NotificationData>> fetchOnly(int limit) async {
    final docs = await FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    final notifications =
        docs.docs.map((doc) => NotificationData.fromDoc(doc)).toList();
    return notifications;
  }

  /// 全部取る
  Future<List<NotificationData>> fetchAll() async {
    final docs = await FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('date', descending: true)
        .get();
    final notifications =
        docs.docs.map((doc) => NotificationData.fromDoc(doc)).toList();
    return notifications;
  }
}
