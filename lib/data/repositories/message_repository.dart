import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/datasources/message_mock_api.dart';
import 'package:yd_app/domain/entities/message.dart';

class MessageRepository {
  final MessageMockApi _api = MessageMockApi();

  Future<List<Message>> fetchMessages() {
    return _api.fetchMessages();
  }

  Future<void> addMessage(Message message) {
    return _api.addMessage(message);
  }
}

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository();
});
