import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';
import 'dart:typed_data';

import '../../repository/functions_repository.dart';
import '../../utils/permission_utils.dart';

class QuestionChatModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  bool isSendingUserMessage = false; // Only for user message sending
  bool hasPermission = false;
  bool isCheckingPermission = true;
  bool get isTeacher => PermissionUtils.isTeacher;
  List<String> questionSuggestions = [];

  // Gemini Model Selection
  String selectedModel = 'gemini-2.5-flash';
  final List<Map<String, String>> availableModels = [
    {
      'value': 'gemini-2.5-flash',
      'label': 'Gemini 2.5 Flash',
      'description': '高速'
    },
    // {'value': 'gemini-2.5-flash-lite-preview-06-17', 'label': 'Gemini 2.5 Flash Lite', 'description': '超高速'},
    {
      'value': 'gemini-2.5-pro',
      'label': 'Gemini 2.5 Pro',
      'description': '高品質'
    },
  ];

  QuestionChatRoom? currentRoom;
  StreamSubscription<List<QuestionChatMessage>>? _messageSubscription;

  final UserRepository _userRepo = UserRepository();
  final FunctionsRepository _functionsRepo = FunctionsRepository();
  final QuestionChatRepository _chatRepo = QuestionChatRepository();
  final StorageRepository _storageRepo = StorageRepository();
  final UserContextRepository _contextRepo = UserContextRepository();
  
  UserContext? userContext;
  bool isLoadingContext = false;

  QuestionChatModel({String? roomId}) {
    _checkPermission();
    _loadUserContext();
    if (roomId != null) {
      _loadExistingRoom(roomId);
    } else {
      _createNewRoom();
      _loadQuestionSuggestions();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    try {
      hasPermission = await PermissionUtils.hasQuestionChatPermission();
    } catch (e) {
      hasPermission = false;
    } finally {
      isCheckingPermission = false;
      notifyListeners();
    }
  }

  Future<void> _loadExistingRoom(String roomId) async {
    try {
      currentRoom = await _chatRepo.getChatRoom(roomId);
      if (currentRoom != null) {
        _subscribeToMessages(roomId);
        // Add user to participants if not already there
        if (!currentRoom!.participants.contains(_userRepo.myUid)) {
          await _chatRepo.addParticipant(roomId, _userRepo.myUid!);
        }
      }
    } catch (e) {
      logger.e('Error loading existing room: $e');
    }
  }

  Future<void> _createNewRoom() async {
    // For new conversations, we'll create the room when the first message is sent
    // This avoids creating empty rooms
  }

  void _subscribeToMessages(String roomId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepo.watchMessages(roomId).listen(
      (firestoreMessages) {
        messages.clear();
        messages.addAll(firestoreMessages.map(_convertToLocalMessage));

        // Simple: if we were sending a user message and now we see any new user message from this user, stop loading
        if (isSendingUserMessage &&
            messages
                .any((msg) => msg.isUser && msg.senderId == _userRepo.myUid)) {
          isSendingUserMessage = false;
        }

        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      onError: (error) {
        logger.e('Error listening to messages: $error');
      },
    );
  }

  ChatMessage _convertToLocalMessage(QuestionChatMessage firestoreMessage) {
    MessageSender localSender;
    switch (firestoreMessage.sender) {
      case QuestionChatMessageSender.user:
        localSender = MessageSender.user;
        break;
      case QuestionChatMessageSender.ai:
        localSender = MessageSender.ai;
        break;
      case QuestionChatMessageSender.instructor:
        localSender = MessageSender.instructor;
        break;
    }

    // メッセージタイプを変換
    MessageType localMessageType;
    switch (firestoreMessage.messageType) {
      case 'image':
        localMessageType = MessageType.image;
        break;
      case 'video':
        localMessageType = MessageType.video;
        break;
      default:
        localMessageType = MessageType.text;
    }

    return ChatMessage(
      content: firestoreMessage.content,
      sender: localSender,
      timestamp: firestoreMessage.createdAt,
      senderId: firestoreMessage.senderId,
      senderName: firestoreMessage.senderName,
      senderAvatar: firestoreMessage.senderAvatar,
      type: localMessageType,
      mediaUrl: firestoreMessage.mediaUrl,
    );
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isLoading || isSendingUserMessage) return;

    // Check for mentions
    final hasMentionKboy = _containsMention(text, 'kboy');

    // Only set sending state for actual user messages (not when teacher/instructor sends)
    if (!isTeacher) {
      isSendingUserMessage = true;
    }
    notifyListeners();

    try {
      // Create room if it doesn't exist
      if (currentRoom == null) {
        await _createRoomForFirstMessage(text);
      }

      if (currentRoom == null) return;

      // Get user display name
      final userDisplayName = await _getUserDisplayName();

      // Determine sender type based on user
      final QuestionChatMessageSender senderType;
      final String senderName;

      if (isTeacher) {
        senderType = QuestionChatMessageSender.instructor;
        senderName = 'kboy';
      } else {
        senderType = QuestionChatMessageSender.user;
        senderName = userDisplayName;
      }

      // Save message to Firestore
      await _chatRepo.sendMessage(
        roomId: currentRoom!.id,
        content: text,
        sender: senderType,
        senderId: _userRepo.myUid ?? 'unknown',
        senderName: senderName,
      );

      // Message sent to Firestore, clear input
      textController.clear();

      // Only call AI if it's a user message (not teacher) and @kboy is not mentioned
      if (!isTeacher && !hasMentionKboy) {
        // Start AI thinking bubble
        isLoading = true;
        notifyListeners();

        try {
          // メッセージ履歴を含めてGemini APIを呼び出し
          final messageHistory = _buildRecentMessageHistory();
          final contextInfo = _buildContextInfo();
          final response = await _callGeminiAPI(
            '必ず日本語で回答してください。回答は500文字以内（コードを送る場合はその限りではない）で簡潔にお答えください。$contextInfo $text',
            messageHistory: messageHistory,
          );

          // Save AI response to Firestore
          await _chatRepo.sendMessage(
            roomId: currentRoom!.id,
            content: response,
            sender: QuestionChatMessageSender.ai,
            senderId: 'ai',
            senderName: 'Flutter大学くん',
          );
        } catch (e) {
          String errorContent = 'エラーが発生しました。もう一度お試しください。';

          if (e is FirebaseFunctionsException) {
            switch (e.code) {
              case 'unauthenticated':
                errorContent = '認証が必要です。再度ログインしてください。';
                break;
              case 'invalid-argument':
                errorContent = '不正な入力です。質問内容を確認してください。';
                break;
              case 'internal':
                errorContent = 'サーバーエラーが発生しました。しばらく待ってから再度お試しください。';
                break;
              default:
                errorContent = 'エラーが発生しました: ${e.message}';
            }
          }

          // Save error message to Firestore
          await _chatRepo.sendMessage(
            roomId: currentRoom!.id,
            content: errorContent,
            sender: QuestionChatMessageSender.ai,
            senderId: 'system',
            senderName: 'システム',
          );
        } finally {
          isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      logger.e('Error sending message: $e');
      // Reset sending state if there was an error
      if (isSendingUserMessage) {
        isSendingUserMessage = false;
        notifyListeners();
      }
    }
  }

  /// Check if text contains a mention of the specified user
  bool _containsMention(String text, String username) {
    final pattern = RegExp(r'@' + RegExp.escape(username) + r'\b', caseSensitive: false);
    return pattern.hasMatch(text);
  }

  Future<void> _createRoomForFirstMessage(String firstMessage) async {
    try {
      final userDisplayName = await _getUserDisplayName();
      final title = _generateRoomTitle(firstMessage);

      currentRoom = await _chatRepo.createChatRoom(
        title: title,
        description: firstMessage,
        createdBy: _userRepo.myUid!,
        createdByName: userDisplayName,
      );

      // Start listening to messages for this room
      _subscribeToMessages(currentRoom!.id);
    } catch (e) {
      logger.e('Error creating room: $e');
      rethrow;
    }
  }

  String _generateRoomTitle(String firstMessage) {
    // Create a short title from the first message
    const maxLength = 50;
    if (firstMessage.length <= maxLength) {
      return firstMessage;
    }
    return '${firstMessage.substring(0, maxLength)}...';
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      // Use a more stable scrolling approach
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Future<void> _loadUserContext() async {
    try {
      isLoadingContext = true;
      notifyListeners();
      
      userContext = await _contextRepo.getUserContext();
      
      isLoadingContext = false;
      notifyListeners();
    } catch (e) {
      logger.e('Error loading user context: $e');
      isLoadingContext = false;
      notifyListeners();
    }
  }

  Future<void> updateUserContext(UserContext context) async {
    try {
      await _contextRepo.saveUserContext(context);
      userContext = context;
      notifyListeners();
    } catch (e) {
      logger.e('Error updating user context: $e');
    }
  }

  Future<String> _callGeminiAPI(String prompt,
      {String? imageUrl, List<Map<String, dynamic>>? messageHistory}) async {
    final result = await _functionsRepo.call(
      functionName: 'api-callGemini',
      parameters: {
        'prompt': prompt,
        'model': selectedModel, // Add selected model parameter
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (messageHistory != null && messageHistory.isNotEmpty)
          'messageHistory': messageHistory,
      },
    );

    return result.data['response'] as String;
  }

  void setSelectedModel(String model) {
    selectedModel = model;
    notifyListeners();
  }

  Future<String> _getUserDisplayName() async {
    try {
      final user = await _userRepo.fetchMyUser();
      return user?.nickname ?? '名無しのユーザー';
    } catch (e) {
      return '名無しのユーザー';
    }
  }

  /// ファイル選択とアップロード機能
  Future<void> selectFile() async {
    try {
      logger.d('ファイル選択機能が呼ばれました');

      // ファイル選択ダイログを表示
      final result = await FilePickerUtils.selectFile();

      if (result == null) {
        logger.d('ファイル選択がキャンセルされました');
        return;
      }

      // ファイルバリデーション
      if (!FilePickerUtils.validateFileType(result.name)) {
        logger.e('サポートされていないファイルタイプ: ${result.name}');
        _showErrorMessage('サポートされていないファイル形式です。JPEG、PNG、WebP形式の画像を選択してください。');
        return;
      }

      if (!FilePickerUtils.validateFileSize(result.bytes)) {
        logger.e('ファイルサイズが大きすぎます: ${result.size} bytes');
        _showErrorMessage('ファイルサイズが大きすぎます。10MB以下のファイルを選択してください。');
        return;
      }

      // アップロード処理を開始
      await _uploadAndSendMediaMessage(
        fileName: result.name,
        fileBytes: result.bytes,
        fileSize: result.size,
      );
    } catch (e) {
      logger.e('ファイル選択エラー: $e');
      _showErrorMessage('ファイルの選択中にエラーが発生しました。');
    }
  }

  /// ファイルアップロードとメディアメッセージ送信
  Future<void> _uploadAndSendMediaMessage({
    required String fileName,
    required Uint8List fileBytes,
    required int fileSize,
  }) async {
    try {
      // ローディング状態を設定
      isLoading = true;
      notifyListeners();

      // チャットルームが存在しない場合は作成
      if (currentRoom == null) {
        await _createRoomForFirstMessage('画像・動画が添付されました');
      }

      if (currentRoom == null) {
        throw Exception('チャットルームの作成に失敗しました');
      }

      // Firebase Storageにアップロード
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          'question_chat/${currentRoom!.id}/${timestamp}_$fileName';
      final downloadUrl = await _storageRepo.uploadData(filePath, fileBytes);

      // メッセージタイプを判定
      final messageType = FilePickerUtils.isImageFile(fileName)
          ? MessageType.image
          : MessageType.video;

      // メディアメッセージを送信
      await _addMediaMessage(
        content: '画像が添付されました', // 今はGemini対応画像形式のみなので「画像」で統一
        mediaUrl: downloadUrl,
        type: messageType,
        fileName: fileName,
      );

      logger.d('ファイルアップロードとメッセージ送信が完了しました');
    } catch (e) {
      logger.e('ファイルアップロードエラー: $e');
      _showErrorMessage('ファイルのアップロードに失敗しました。');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// エラーメッセージを表示
  void _showErrorMessage(String message) {
    // TODO: 実際のエラートーストやダイアログを表示
    logger.e('エラー: $message');
  }

  /// 直近のメッセージ履歴を構築（Geminiコンテキスト用）
  List<Map<String, dynamic>> _buildRecentMessageHistory(
      {int maxMessages = 10}) {
    // AIとユーザーのメッセージのみを抽出（講師メッセージは除外）
    final relevantMessages = messages
        .where((msg) =>
            msg.sender == MessageSender.user || msg.sender == MessageSender.ai)
        .toList();

    // 直近のメッセージのみを取得
    final recentMessages = relevantMessages.length > maxMessages
        ? relevantMessages.sublist(relevantMessages.length - maxMessages)
        : relevantMessages;

    return recentMessages.map((msg) {
      return {
        'role': msg.sender == MessageSender.ai ? 'model' : 'user',
        'content': msg.content,
        'timestamp': msg.timestamp.toIso8601String(),
      };
    }).toList();
  }

  /// ユーザーコンテキスト情報を構築
  String _buildContextInfo() {
    if (userContext == null || !userContext!.isComplete) {
      return '';
    }
    
    String contextInfo = '【ユーザー環境情報】';
    contextInfo += 'OS: ${userContext!.os}';
    
    if (userContext!.chip != null) {
      contextInfo += ', プロセッサー: ${userContext!.chip}';
    }
    
    contextInfo += ', IDE: ${userContext!.ide}';
    contextInfo += '。この環境に最適化したアドバイスをお願いします。';
    
    return contextInfo;
  }

  /// Geminiで画像分析を実行
  Future<void> _analyzeImageWithGemini(String imageUrl) async {
    try {
      logger.d('Gemini画像分析を開始: $imageUrl');

      // ローディング状態を設定
      isLoading = true;
      notifyListeners();

      // Gemini 2.0 Flashで画像分析（コンテキスト付き）
      final messageHistory = _buildRecentMessageHistory();
      final aiResponse = await _callGeminiAPI(
        '必ず日本語で回答してください。回答は500文字以内で簡潔にお答えください。テキストでの質問がない場合は、簡潔に画像の内容を説明した後に具体的な質問を促してください。',
        imageUrl: imageUrl,
        messageHistory: messageHistory,
      );

      // AI分析結果をチャットに追加
      await _chatRepo.sendMessage(
        roomId: currentRoom!.id,
        content: aiResponse,
        sender: QuestionChatMessageSender.ai,
        senderId: 'ai',
        senderName: 'Flutter大学くん',
      );

      logger.d('Gemini画像分析完了');
    } catch (e) {
      logger.e('Gemini画像分析エラー: $e');

      // エラー時はシンプルなメッセージを送信
      try {
        await _chatRepo.sendMessage(
          roomId: currentRoom!.id,
          content:
              '画像の分析中にエラーが発生しました。JPEG、PNG、WebP形式の画像を使用するか、テキストで質問内容をお聞かせください。',
          sender: QuestionChatMessageSender.ai,
          senderId: 'system',
          senderName: 'システム',
        );
      } catch (e2) {
        logger.e('エラーメッセージ送信失敗: $e2');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// メディアメッセージを追加
  Future<void> _addMediaMessage({
    required String content,
    required String mediaUrl,
    required MessageType type,
    String? fileName,
  }) async {
    try {
      final userDisplayName = await _getUserDisplayName();
      final senderType = isTeacher
          ? QuestionChatMessageSender.instructor
          : QuestionChatMessageSender.user;
      final senderName = isTeacher ? 'kboy' : userDisplayName;

      // ローカルメッセージを追加
      messages.add(ChatMessage(
        content: content,
        sender: isTeacher ? MessageSender.instructor : MessageSender.user,
        timestamp: DateTime.now(),
        senderId: _userRepo.myUid,
        senderName: senderName,
        type: type,
        mediaUrl: mediaUrl,
        fileName: fileName,
      ));

      notifyListeners();
      _scrollToBottom();

      // Firestoreに保存
      if (currentRoom != null) {
        await _chatRepo.sendMessage(
          roomId: currentRoom!.id,
          content: content,
          sender: senderType,
          senderId: _userRepo.myUid!,
          senderName: senderName,
          mediaUrl: mediaUrl,
          messageType: type == MessageType.image ? 'image' : 'video',
        );

        // 画像の場合はGemini分析を実行（ユーザーメッセージのみ、teacherは対象外）
        if (type == MessageType.image && !isTeacher) {
          await _analyzeImageWithGemini(mediaUrl);
        }
      }
    } catch (e) {
      logger.e('メディアメッセージ送信エラー: $e');
    }
  }

  /// 過去の質問履歴から提案を読み込む
  Future<void> _loadQuestionSuggestions() async {
    try {
      // 最近のチャットルームを取得
      final chatRoomsStream = _chatRepo.watchChatRooms();
      final chatRooms = await chatRoomsStream.first;

      // チャットルームのタイトルから質問の提案を作成
      final suggestions = <String>[];

      for (final room in chatRooms.take(10)) {
        // 最新10件を取得
        final title = room.title.trim();
        if (title.isNotEmpty && title.length <= 50) {
          suggestions.add(title);
        }
      }

      // デフォルトの提案も含める（履歴が少ない場合）
      final defaultSuggestions = [
        'StatefulWidgetの使い方は？',
        'Providerパターンについて',
        'アニメーションの実装方法',
        '@kboy アプリ設計について相談したいです',
      ];

      // 履歴からの提案を優先し、足りない分はデフォルトで補完
      questionSuggestions = suggestions.isNotEmpty
          ? suggestions.take(4).toList()
          : defaultSuggestions;

      // 4つに満たない場合はデフォルトで補完
      while (questionSuggestions.length < 4) {
        for (final defaultSuggestion in defaultSuggestions) {
          if (!questionSuggestions.contains(defaultSuggestion) &&
              questionSuggestions.length < 4) {
            questionSuggestions.add(defaultSuggestion);
          }
        }
      }

      notifyListeners();
    } catch (e) {
      logger.e('Error loading question suggestions: $e');
      // エラー時はデフォルトの提案を使用
      questionSuggestions = [
        'StatefulWidgetの使い方は？',
        'Providerパターンについて',
        'アニメーションの実装方法',
        '@kboy アプリ設計について相談したいです',
      ];
      notifyListeners();
    }
  }
}
