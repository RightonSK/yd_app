import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/question_chat_room.dart';
import 'package:salon_app_commons/domain/question_chat_message.dart';
import 'package:salon_app_commons/utils/log_utils.dart';

class QuestionChatRepository {
  static QuestionChatRepository? _instance;
  QuestionChatRepository._internal();

  factory QuestionChatRepository() {
    return _instance ??= QuestionChatRepository._internal();
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // コレクション参照
  CollectionReference<QuestionChatRoom> get _questionsRef =>
      _db.collection('questions').withConverter<QuestionChatRoom>(
            fromFirestore: QuestionChatRoom.fromFirestore,
            toFirestore: (QuestionChatRoom room, _) => room.toFirestore(),
          );

  // メッセージは特定の質問の下のサブコレクション
  CollectionReference<QuestionChatMessage> _messagesRef(String questionId) =>
      _db.collection('questions').doc(questionId).collection('messages').withConverter<QuestionChatMessage>(
            fromFirestore: QuestionChatMessage.fromFirestore,
            toFirestore: (QuestionChatMessage message, _) => message.toFirestore(),
          );

  /// 新しいチャットルームを作成
  Future<QuestionChatRoom> createChatRoom({
    required String title,
    String? description,
    required String createdBy,
    required String createdByName,
  }) async {
    try {
      final now = DateTime.now();
      final room = QuestionChatRoom(
        id: '', // Firestoreが自動生成
        title: title,
        description: description,
        createdBy: createdBy,
        createdByName: createdByName,
        createdAt: now,
        updatedAt: now,
        participants: [createdBy],
        isActive: true,
        messageCount: 0,
      );

      final docRef = await _questionsRef.add(room);
      final createdRoom = await docRef.get();
      return createdRoom.data()!.copyWith(id: docRef.id);
    } catch (e) {
      logger.e('Error creating chat room: $e');
      rethrow;
    }
  }

  /// チャットルーム一覧を取得（AI修行プラン限定）
  Stream<List<QuestionChatRoom>> watchChatRooms() {
    try {
      logger.d('Starting to watch chat rooms...');
      return _questionsRef
          .where('isActive', isEqualTo: true)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        logger.d('Received ${snapshot.docs.length} chat rooms from Firestore');
        final rooms = snapshot.docs.map((doc) => doc.data().copyWith(id: doc.id)).toList();
        logger.d('Parsed chat rooms: ${rooms.length}');
        return rooms;
      });
    } catch (e) {
      logger.e('Error watching chat rooms: $e');
      return Stream.value([]);
    }
  }

  /// 特定のチャットルームを取得
  Future<QuestionChatRoom?> getChatRoom(String roomId) async {
    try {
      final doc = await _questionsRef.doc(roomId).get();
      if (!doc.exists) return null;
      return doc.data()!.copyWith(id: doc.id);
    } catch (e) {
      logger.e('Error getting chat room: $e');
      return null;
    }
  }

  /// チャットルームのメッセージ一覧を監視
  Stream<List<QuestionChatMessage>> watchMessages(String roomId) {
    try {
      return _messagesRef(roomId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data().copyWith(id: doc.id)).toList());
    } catch (e) {
      logger.e('Error watching messages: $e');
      return Stream.value([]);
    }
  }

  /// メッセージを送信
  Future<QuestionChatMessage> sendMessage({
    required String roomId,
    required String content,
    required QuestionChatMessageSender sender,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    String? mediaUrl,
    String? messageType,
  }) async {
    try {
      final now = DateTime.now();
      final message = QuestionChatMessage(
        id: '', // Firestoreが自動生成
        roomId: roomId,
        content: content,
        sender: sender,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        createdAt: now,
        isDeleted: false,
        mediaUrl: mediaUrl,
        messageType: messageType ?? 'text',
      );

      // メッセージを追加
      final docRef = await _messagesRef(roomId).add(message);

      // チャットルームの最終メッセージ情報を更新
      await _updateRoomLastMessage(roomId, content, now);

      final createdMessage = await docRef.get();
      return createdMessage.data()!.copyWith(id: docRef.id);
    } catch (e) {
      logger.e('Error sending message: $e');
      rethrow;
    }
  }

  /// チャットルームの最終メッセージ情報を更新
  Future<void> _updateRoomLastMessage(
    String roomId,
    String lastMessageContent,
    DateTime lastMessageAt,
  ) async {
    try {
      await _questionsRef.doc(roomId).update({
        'lastMessageContent': lastMessageContent,
        'lastMessageAt': Timestamp.fromDate(lastMessageAt),
        'updatedAt': Timestamp.fromDate(lastMessageAt),
        'messageCount': FieldValue.increment(1),
      });
    } catch (e) {
      logger.e('Error updating room last message: $e');
      // メッセージ送信は成功させたいので、ここではエラーを投げない
    }
  }

  /// ユーザーをチャットルームに参加させる
  Future<void> addParticipant(String roomId, String userId) async {
    try {
      await _questionsRef.doc(roomId).update({
        'participants': FieldValue.arrayUnion([userId]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      logger.e('Error adding participant: $e');
      rethrow;
    }
  }

  /// チャットルームを無効化（削除）
  Future<void> deactivateChatRoom(String roomId) async {
    try {
      await _questionsRef.doc(roomId).update({
        'isActive': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      logger.e('Error deactivating chat room: $e');
      rethrow;
    }
  }
}
