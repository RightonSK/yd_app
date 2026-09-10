import 'package:cloud_firestore/cloud_firestore.dart';

class VideoComment {
  final String id;
  final String? commentText;
  final Timestamp createdAt;
  final String? name;
  final String? photoURL;
  final String userId;

  VideoComment._(this.id, this.commentText, this.createdAt, this.name,
      this.photoURL, this.userId);

  factory VideoComment.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return VideoComment._(doc.id, data['commentText'], data['createdAt'],
        data['name'], data['photoURL'], data['userId']);
  }
}
