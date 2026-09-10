import 'package:cloud_firestore/cloud_firestore.dart';

class EventParticipant {
  final String id;
  final DateTime? createdAt;

  EventParticipant._(
    this.id,
    this.createdAt,
  );

  factory EventParticipant.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventParticipant._(
      doc.id,
      _toDate(data, 'createdAt'),
    );
  }

  /// Timestamp => DateTime
  static DateTime? _toDate(Map<String, dynamic> data, String fieldName) {
    DateTime? dTime;
    if (data[fieldName] is Timestamp) {
      dTime = (data[fieldName] as Timestamp).toDate();
    }
    return dTime;
  }
}
