// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';

import 'content.dart';

/// ユーザ
class Video extends Content {
  @override
  final String id;

  @override
  final String image;

  @override
  final DateTime createdAt;

  @override
  final String title;

  final String? description;
  final String? link;
  final int? duration;
  final String? url;
  final bool? hideInReview;
  String? userId;
  int? likeCount;

  Video._(
    this.id,
    this.image,
    this.title,
    this.description,
    this.link,
    this.duration,
    this.url,
    this.createdAt,
    this.hideInReview,
    this.userId,
    this.likeCount,
  );

  factory Video.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return Video._(
      doc.id,
      data['thumbURL'],
      data['name'],
      data['description'],
      data['link'],
      data['duration'],
      data['url'],
      data['createdAt'].toDate(),
      data['hideInReview'] ?? false,
      data['userId'],
      data['likeCount'] ?? 0,
    );
  }
}
