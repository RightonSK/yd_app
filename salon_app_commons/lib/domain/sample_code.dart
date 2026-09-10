import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/content.dart';

class SampleCode extends Content {
  @override
  final String id;

  @override
  final String title;

  @override
  final DateTime createdAt;

  @override
  final String image =
      'https://cdn.textstudio.com/output/graphic/preview/large/0/6/9/9/9960_a863ac94.webp';

  final String githubURL;
  final String description;

  SampleCode(
    this.id,
    this.title,
    this.githubURL,
    this.description,
    this.createdAt,
  );

  factory SampleCode.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SampleCode(
      doc.id,
      data['name'],
      data['githubURL'],
      data['description'],
      _toDate(data, 'createdAt'),
    );
  }

  /// Timestamp => DateTime
  static DateTime _toDate(Map<String, dynamic> data, String fieldName) {
    if (data[fieldName] is Timestamp) {
      return (data[fieldName] as Timestamp).toDate();
    } else {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = title;
    data['githubURL'] = githubURL;
    data['description'] = description;
    data['createdAt'] = createdAt;
    return data;
  }
}
