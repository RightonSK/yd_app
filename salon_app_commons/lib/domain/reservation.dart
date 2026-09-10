import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/extensions/date_time.dart';

class Reservation {
  static const int limitCount = 3;

  final String id;
  final String userId;
  final String? userName;
  final String? userImageURL;
  final String? eventName;
  final DateTime? start;
  final DateTime? end;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageURL,
    required this.eventName,
    required this.start,
    required this.end,
    required this.createdAt,
  });

  factory Reservation.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reservation.fromJson(data);
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImageURL: json['userImageURL'],
      eventName: json['eventName'],
      start: DateTimeEx.fromTimestamp(json['start']),
      end: DateTimeEx.fromTimestamp(json['end']),
      createdAt: DateTimeEx.fromTimestamp(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userImageURL': userImageURL,
        'eventName': eventName,
        'start': start,
        'end': end,
        'createdAt': createdAt,
      };
}
