import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String id;
  final DateTime? createdAt;
  final String title;
  final String description;
  final String imageURL;
  final String url;
  final String ctaText;

  Reward(
    this.id,
    this.createdAt,
    this.title,
    this.description,
    this.imageURL,
    this.url,
    this.ctaText,
  );

  factory Reward.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reward(
      doc.id,
      _toDate(data, 'createdAt'),
      data['title'],
      data['description'],
      data['imageURL'],
      data['url'],
      data['ctaText'] ?? 'サイトへ',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['title'] = title;
    data['description'] = description;
    data['imageURL'] = imageURL;
    data['url'] = url;
    data['ctaText'] = ctaText;
    return data;
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
