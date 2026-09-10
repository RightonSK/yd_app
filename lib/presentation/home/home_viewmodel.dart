import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/repositories/message_repository.dart';
import 'package:yd_app/domain/entities/message.dart';

final messagesProvider2 = FutureProvider<List<Message>>((ref) {
  return ref.watch(messageRepositoryProvider).fetchMessages();
});

final messagesProvider = AsyncNotifierProvider<MessageNotifier, List<Message>>(MessageNotifier.new);

class MessageNotifier extends AsyncNotifier<List<Message>> {
  @override
  Future<List<Message>> build() async {
    final messages = await ref.watch(messageRepositoryProvider).fetchMessages();
    return messages;
  }
}

// class BugsEncounteredNotifier extends AsyncNotifier<int> {
//   BugsEncounteredNotifier(this.arg);
//   final String arg;
//
//   @override
//   FutureOr<int> build() async{
//     return 99;
//   }
//
//   Future<void> fix(int amount) async {
//     final old = await future;
//     final result =
//     await ref.read(taskTrackerProvider).fix(id: this.arg, fixed: amount);
//     state = AsyncData(max(old - result, 0));
//   }
// }

// final bugsEncounteredNotifierProvider = AsyncNotifierProvider.family
//     .autoDispose<BugsEncounteredNotifier, int, String>(
//   BugsEncounteredNotifier.new,
// );





