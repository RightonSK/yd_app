import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/repositories/message_repository.dart';
import 'package:yd_app/domain/entities/message.dart';

final messagesProvider = FutureProvider<List<Message>>((ref) {
  return ref.watch(messageRepositoryProvider).fetchMessages();
});
