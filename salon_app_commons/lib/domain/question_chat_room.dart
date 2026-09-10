import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionChatRoom {
  final String id;
  final String title;
  final String? description;
  final String createdBy;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> participants;
  final bool isActive;
  final int messageCount;
  final String? lastMessageContent;
  final DateTime? lastMessageAt;

  QuestionChatRoom({
    required this.id,
    required this.title,
    this.description,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
    this.isActive = true,
    this.messageCount = 0,
    this.lastMessageContent,
    this.lastMessageAt,
  });

  factory QuestionChatRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return QuestionChatRoom(
      id: snapshot.id,
      title: data?['title'] ?? '',
      description: data?['description'],
      createdBy: data?['createdBy'] ?? '',
      createdByName: data?['createdByName'] ?? '',
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data?['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participants: List<String>.from(data?['participants'] ?? []),
      isActive: data?['isActive'] ?? true,
      messageCount: data?['messageCount'] ?? 0,
      lastMessageContent: data?['lastMessageContent'],
      lastMessageAt: (data?['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'participants': participants,
      'isActive': isActive,
      'messageCount': messageCount,
      'lastMessageContent': lastMessageContent,
      'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
    };
  }

  QuestionChatRoom copyWith({
    String? id,
    String? title,
    String? description,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? participants,
    bool? isActive,
    int? messageCount,
    String? lastMessageContent,
    DateTime? lastMessageAt,
  }) {
    return QuestionChatRoom(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      participants: participants ?? this.participants,
      isActive: isActive ?? this.isActive,
      messageCount: messageCount ?? this.messageCount,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}