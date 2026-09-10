import 'package:cloud_firestore/cloud_firestore.dart';

import 'content.dart';

/// 教材
class StudyContent extends Content {
  @override
  final String id;

  @override
  final String title;

  @override
  final String image;

  // ここでは使ってないので
  @override
  final DateTime createdAt = DateTime.now();

  String? part;

  StudyContent({
    required this.id,
    required this.title,
    required this.part,
    required this.image,
  });

  factory StudyContent.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return StudyContent(
      id: doc.id,
      title: data['title'] ?? '',
      part: data['part'] ?? '',
      image: data['thumbURL'] ?? '',
    );
  }
}
