import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'question_chat_list_model.dart';
import '../question_chat/question_chat_page.dart';
import '../../domain/question_chat_room.dart';

class QuestionChatListPage extends StatelessWidget {
  static const String route = '/questions';

  const QuestionChatListPage({
    super.key,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: ChangeNotifierProvider<QuestionChatListModel>(
        create: (_) => QuestionChatListModel(),
        child: Consumer<QuestionChatListModel>(
          builder: (context, model, child) {
            // Permission checking
            if (model.isCheckingPermission) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // No permission - show upgrade message
            if (!model.hasPermission) {
              return _buildNoPermissionView(context);
            }

            return Column(
              children: [
                // New Question Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(QuestionChatPage.route('new'));
                    },
                    icon: const Icon(
                      Icons.add_comment,
                      color: Colors.white,
                    ),
                    label: const Text('新しい質問をする'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryNavyColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Chat Room List
                Expanded(
                  child: model.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : model.chatRooms.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: () async => model.refresh(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: model.chatRooms.length,
                                itemBuilder: (context, index) {
                                  final room = model.chatRooms[index];
                                  return _buildChatRoomCard(context, room, model);
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'まだ質問履歴がありません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter AIに質問して\nプログラミングスキルを向上させましょう！',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomCard(
    BuildContext context,
    QuestionChatRoom room,
    QuestionChatListModel model,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to specific chat room
          context.push(QuestionChatPage.route(room.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and metadata
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${room.createdByName} • ${model.formatCreatedDate(room.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (room.lastMessageAt != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      model.formatLastMessageTime(room.lastMessageAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),

              // Last message preview
              if (room.lastMessageContent != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    room.lastMessageContent!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Message count and participants
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble,
                    size: 16,
                    color: primaryNavyColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${room.messageCount}件のメッセージ',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryNavyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoPermissionView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'AI修行プラン限定機能',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AI質問履歴機能は\nAI修行プランのメンバー限定です',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            if (kIsWeb)
              ElevatedButton(
                onPressed: () {
                  context.go('/changePlan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'プランをアップグレード',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
