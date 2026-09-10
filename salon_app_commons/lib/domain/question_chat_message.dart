import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionChatMessageSender {
  user,
  ai,
  instructor,
}

class QuestionChatMessage {
  final String id;
  final String roomId;
  final String content;
  final QuestionChatMessageSender sender;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime createdAt;
  final bool isDeleted;
  final String? mediaUrl;
  final String? messageType; // 'text', 'image', 'video'

  QuestionChatMessage({
    required this.id,
    required this.roomId,
    required this.content,
    required this.sender,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.createdAt,
    this.isDeleted = false,
    this.mediaUrl,
    this.messageType = 'text',
  });

  factory QuestionChatMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return QuestionChatMessage(
      id: snapshot.id,
      roomId: data?['roomId'] ?? '',
      content: data?['content'] ?? '',
      sender: QuestionChatMessageSender.values.firstWhere(
        (e) => e.name == data?['sender'],
        orElse: () => QuestionChatMessageSender.user,
      ),
      senderId: data?['senderId'] ?? '',
      senderName: data?['senderName'] ?? '',
      senderAvatar: data?['senderAvatar'],
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDeleted: data?['isDeleted'] ?? false,
      mediaUrl: data?['mediaUrl'],
      messageType: data?['messageType'] ?? 'text',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomId': roomId,
      'content': content,
      'sender': sender.name,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'createdAt': Timestamp.fromDate(createdAt),
      'isDeleted': isDeleted,
      'mediaUrl': mediaUrl,
      'messageType': messageType,
    };
  }

  QuestionChatMessage copyWith({
    String? id,
    String? roomId,
    String? content,
    QuestionChatMessageSender? sender,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    DateTime? createdAt,
    bool? isDeleted,
    String? mediaUrl,
    String? messageType,
  }) {
    return QuestionChatMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      messageType: messageType ?? this.messageType,
    );
  }
}
