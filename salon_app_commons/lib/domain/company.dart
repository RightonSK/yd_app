import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  Company({
    required this.name,
    required this.reference,
    required this.corporateSiteUrl,
    required this.imageUrl,
    required this.description,
    this.isApproved = false,
  });
  factory Company.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Company(
      name: data?['name'],
      reference: snapshot.reference,
      corporateSiteUrl: data?['corporateSiteUrl'],
      imageUrl: data?['imageUrl'],
      description: data?['description'],
      isApproved: data?['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'corporateSiteUrl': corporateSiteUrl,
      'imageUrl': imageUrl,
      'description': description,
      'isApproved': isApproved,
    };
  }

  Company copyWith({
    String? name,
    DocumentReference? reference,
    String? corporateSiteUrl,
    String? imageUrl,
    String? description,
  }) {
    return Company(
      name: name ?? this.name,
      reference: reference ?? this.reference,
      corporateSiteUrl: corporateSiteUrl ?? this.corporateSiteUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  static const collectionPath = 'companies';

  final String? name;
  final DocumentReference? reference;
  final String? corporateSiteUrl;
  final String? imageUrl;
  final String? description;
  final bool isApproved;
}
