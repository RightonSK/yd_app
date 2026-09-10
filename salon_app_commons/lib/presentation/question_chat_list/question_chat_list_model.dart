import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'dart:async';
import '../../utils/permission_utils.dart';

class QuestionChatListModel extends ChangeNotifier {
  bool hasPermission = false;
  bool isCheckingPermission = true;
  List<QuestionChatRoom> chatRooms = [];
  bool isLoading = false;
  StreamSubscription<List<QuestionChatRoom>>? _roomSubscription;
  bool get isTeacher => PermissionUtils.isTeacher;

  final QuestionChatRepository _chatRepo = QuestionChatRepository();

  QuestionChatListModel() {
    _checkPermission();
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    try {
      logger.d('Checking user permission...');
      hasPermission = await PermissionUtils.hasQuestionChatPermission();
      logger.d('User has permission: $hasPermission');

      if (hasPermission) {
        _loadChatRooms();
      } else {
        logger.d('User does not have permission to access chat rooms');
      }
    } catch (e) {
      hasPermission = false;
      logger.e('Error checking permission: $e');
    } finally {
      isCheckingPermission = false;
      notifyListeners();
    }
  }

  void _loadChatRooms() {
    logger.d('Loading chat rooms...');
    isLoading = true;
    notifyListeners();

    _roomSubscription?.cancel();
    _roomSubscription = _chatRepo.watchChatRooms().listen(
      (rooms) {
        logger.d('Received ${rooms.length} chat rooms in model');
        chatRooms = rooms;
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        logger.e('Error loading chat rooms: $error');
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void refresh() {
    isLoading = true;
    notifyListeners();
    _loadChatRooms();
  }

  String formatLastMessageTime(DateTime? lastMessageAt) {
    if (lastMessageAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastMessageAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }

  String formatCreatedDate(DateTime createdAt) {
    return '${createdAt.year}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.day.toString().padLeft(2, '0')}';
  }
}
