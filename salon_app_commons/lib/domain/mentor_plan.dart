// TODO(any): いったんCodeBoyから拝借、ちゃんと設計してRepository作ったら乗り換える
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/user.dart';

class MentorPlan {
  final String id;
  final String title;
  final String description;
  final int price;
  final int futAmount;
  final String? stripePriceId;
  final bool isPublic;
  final bool isSubscription;
  final bool isPurchased;
  final bool isArchived;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // collectionGroupの時使う
  String? userId;
  User? user;

  MentorPlan._({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.futAmount,
    required this.stripePriceId,
    required this.isPublic,
    required this.isSubscription,
    required this.isPurchased,
    required this.isArchived,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MentorPlan.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MentorPlan._(
      id: doc.id,
      title: data['title'] ?? 'タイトルなし',
      description: data['description'] ?? '説明なし',
      price: data['price'] ?? 0,
      futAmount: data['futAmount'] ?? 0,
      stripePriceId: data['stripePriceId'],
      isPublic: data['isPublic'] ?? false,
      isSubscription: data['isSubscription'] ?? false,
      isPurchased: data['isPurchased'] ?? false,
      isArchived: data['isArchived'] ?? false,
      imageUrl: data['imageUrl'],
      createdAt: _toDate(data, 'createdAt') ?? DateTime.now(),
      updatedAt: _toDate(data, 'updatedAt') ?? DateTime.now(),
    );
  }

  static DateTime? _toDate(Map<String, dynamic> data, String fieldName) {
    DateTime? dTime;
    if (data[fieldName] is Timestamp) {
      dTime = (data[fieldName] as Timestamp).toDate();
    }
    return dTime;
  }
}
