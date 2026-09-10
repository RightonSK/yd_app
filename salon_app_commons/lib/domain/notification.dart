import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  NotificationData({
    this.title,
    this.text,
    this.date,
    this.imageURL,
    this.moreLinkURL,
  });

  final String? title;
  final String? text;
  final DateTime? date;
  final String? imageURL;
  final String? moreLinkURL;

  factory NotificationData.fromDoc(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    return NotificationData(
      title: data['title'],
      text: data['text'],
      date: data['date'].toDate(),
      imageURL: data['imageURL'],
      moreLinkURL: data['moreLinkURL'],
    );
  }
}
