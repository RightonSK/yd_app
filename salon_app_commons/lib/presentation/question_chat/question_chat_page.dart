import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlighting/languages/dart.dart';
import 'package:highlighting/languages/javascript.dart';
import 'package:highlighting/languages/python.dart';
import 'package:highlighting/languages/json.dart';
import 'package:highlighting/languages/yaml.dart';
import 'package:highlighting/languages/sql.dart';
import 'package:highlighting/languages/xml.dart';
import 'package:highlighting/languages/css.dart';
import 'package:highlighting/highlighting.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:salon_app_commons/salon_app_commons.dart';

import 'question_chat_model.dart';

class QuestionChatPage extends StatelessWidget {
  static String route(String roomId) {
    return '/questions/$roomId';
  }

  const QuestionChatPage({
    super.key,
    this.appBar,
    this.roomId,
  });

  final PreferredSizeWidget? appBar;
  final String? roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: ChangeNotifierProvider<QuestionChatModel>(
        create: (_) => QuestionChatModel(roomId: roomId),
        child: Consumer<QuestionChatModel>(
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
                // User context questions (shown when context is incomplete or null)
                if (model.userContext == null || !model.userContext!.isComplete)
                  UserContextQuestions(
                    initialContext: model.userContext,
                    onContextChanged: (context) {
                      model.updateUserContext(context);
                    },
                  ),

                // Chat messages
                Expanded(
                  child: model.messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: model.scrollController,
                          padding: const EdgeInsets.all(16),
                          physics: const ClampingScrollPhysics(),
                          itemCount: model.messages.length + (model.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == model.messages.length && model.isLoading) {
                              return _buildLoadingIndicator();
                            }
                            final message = model.messages[index];
                            return _buildMessageBubble(message);
                          },
                        ),
                ),

                // Input area
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    kIsWeb ? 88 : 16,
                    16,
                  ), // Added 70px right padding for ChannelTalk button
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      // AI Model dropdown
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: model.selectedModel,
                            isDense: true,
                            underline: const SizedBox(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                            ),
                            items: model.availableModels.map((modelInfo) {
                              return DropdownMenuItem<String>(
                                value: modelInfo['value'],
                                child: Text(
                                  '${modelInfo['label']} \n(${modelInfo['description']})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: kIsWeb ? 11 : 6,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                model.setSelectedModel(newValue);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          // ファイル選択ボタン
                          IconButton(
                            onPressed: (model.isLoading || model.isSendingUserMessage)
                                ? null
                                : () {
                                    model.selectFile();
                                  },
                            icon: const Icon(Icons.image),
                            tooltip: '画像添付',
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CallbackShortcuts(
                          bindings: {
                            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.enter): () {
                              model.sendMessage();
                            },
                          },
                          child: TextField(
                            controller: model.textController,
                            //minLines: 1, // 可変だとやっぱりおかしくなるのでmaxだけ
                            maxLines: 3, // maxLines: nullにすると日本語入力がおかしくなるので、minを1にした状態でこの設定がベスト
                            enableIMEPersonalizedLearning: false,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Flutterについて質問してください...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            onSubmitted: (_) => model.sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (model.isLoading || model.isSendingUserMessage) ? null : model.sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryNavyColor,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: (model.isSendingUserMessage)
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                      ),
                    ],
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
    return Consumer<QuestionChatModel>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                'Flutter質問チャット',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Flutter大学くん(AI)と講師kboyがお答えします\nウィジェット、状態管理、アニメーションなど\nFlutterに関することなら何でもお聞きください',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: primaryNavyColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'メンション機能',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryNavyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@kboy と入力すると講師に直接質問できます\n（AIは自動回答しません）',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryNavyColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    model.questionSuggestions.map((suggestion) => _buildSuggestionChip(suggestion, model)).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestionChip(String text, QuestionChatModel model) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        model.textController.text = text;
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: const AssetImage('resources/icon.jpg'),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    'Flutter大学くん',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '考えています...',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
              'AI質問チャット機能は\nAI修行プランのメンバー限定です',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 32,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Flutter修行プランで利用可能',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Gemini AIによるFlutter質問サポート\n• コード例を含む詳細な解説\n• 24時間いつでも利用可能',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(message),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!message.isUser && message.senderName != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getMessageBubbleColor(message),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // メディア表示
                      if (message.hasMedia) ...[
                        _buildMediaContent(message),
                        if (message.content.isNotEmpty) const SizedBox(height: 8),
                      ],
                      // テキスト表示
                      if (message.content.isNotEmpty) _buildMessageText(message),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(message),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageText(ChatMessage message) {
    if (message.sender == MessageSender.ai) {
      // Use custom markdown widget with copy functionality
      return Builder(
        builder: (context) => _buildMarkdownWithCopyButton(message, context),
      );
    } else {
      // Use regular selectable text for user messages
      return SelectableText(
        message.content,
        style: TextStyle(
          color: _getMessageTextColor(message),
          fontSize: 14,
        ),
      );
    }
  }

  Widget _buildMarkdownWithCopyButton(ChatMessage message, BuildContext context) {
    // Split content into parts to handle code blocks separately
    final content = message.content;
    final codeBlockRegex = RegExp(r'```(\w+)?\n([\s\S]*?)```');
    final matches = codeBlockRegex.allMatches(content);

    if (matches.isEmpty) {
      // No code blocks, use regular markdown
      return MarkdownBody(
        data: content,
        selectable: true,
        styleSheet: _getMarkdownStyleSheet(message),
        onTapLink: (text, href, title) {
          if (href != null) {
            URLUtils.launch(urlString: href, shouldOpenNewTab: true);
          }
        },
      );
    }

    // Build widget with custom code blocks
    List<Widget> widgets = [];
    int lastEnd = 0;

    for (final match in matches) {
      // Add text before code block
      if (match.start > lastEnd) {
        final beforeText = content.substring(lastEnd, match.start);
        if (beforeText.trim().isNotEmpty) {
          widgets.add(
            MarkdownBody(
              data: beforeText,
              selectable: true,
              styleSheet: _getMarkdownStyleSheet(message),
              onTapLink: (text, href, title) {
                if (href != null) {
                  URLUtils.launch(urlString: href, shouldOpenNewTab: true);
                }
              },
            ),
          );
        }
      }

      // Add code block with copy button
      final language = match.group(1) ?? '';
      final code = match.group(2) ?? '';
      widgets.add(_buildCodeBlockWithCopy(code, language, context));

      lastEnd = match.end;
    }

    // Add remaining text after last code block
    if (lastEnd < content.length) {
      final afterText = content.substring(lastEnd);
      if (afterText.trim().isNotEmpty) {
        widgets.add(
          MarkdownBody(
            data: afterText,
            selectable: true,
            styleSheet: _getMarkdownStyleSheet(message),
            onTapLink: (text, href, title) {
              if (href != null) {
                URLUtils.launch(urlString: href, shouldOpenNewTab: true);
              }
            },
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildCodeBlockWithCopy(String code, String language, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language and copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (language.isNotEmpty) ...[
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const Spacer(),
                ],
                if (language.isEmpty) const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('コードをクリップボードにコピーしました'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy,
                          size: 16,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'コピー',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: _buildHighlightedCode(code, language),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(ChatMessage message) {
    return MarkdownStyleSheet(
      p: TextStyle(
        color: _getMessageTextColor(message),
        fontSize: 14,
        height: 1.4,
      ),
      code: TextStyle(
        backgroundColor: Colors.grey.shade200,
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      blockquote: TextStyle(
        color: Colors.grey.shade600,
        fontStyle: FontStyle.italic,
        fontSize: 14,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade400, width: 4),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12),
      h1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _getMessageTextColor(message),
      ),
      h2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _getMessageTextColor(message),
      ),
      h3: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: _getMessageTextColor(message),
      ),
      listBullet: TextStyle(
        color: _getMessageTextColor(message),
        fontSize: 14,
      ),
    );
  }

  Widget _buildMediaContent(ChatMessage message) {
    if (!message.hasMedia) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: message.isImage
            ? Image.network(
                message.mediaUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              )
            : message.isVideo
                ? Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: InkWell(
                          onTap: () {
                            // TODO: 動画再生機能
                            // URLUtils.launch(urlString: message.mediaUrl!);
                          },
                          child: Container(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildAvatar(ChatMessage message) {
    switch (message.sender) {
      case MessageSender.user:
        // TODO: Use actual user avatar
        return CircleAvatar(
          radius: 16,
          backgroundColor: Colors.green.shade100,
          child: Icon(
            Icons.person,
            size: 16,
            color: Colors.green.shade700,
          ),
        );
      case MessageSender.ai:
        return CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: const AssetImage('resources/icon.jpg'),
        );
      case MessageSender.instructor:
        // TODO: Use actual instructor avatar
        return CircleAvatar(
          radius: 16,
          backgroundColor: Colors.orange.shade100,
          child: Icon(
            Icons.school,
            size: 16,
            color: Colors.orange.shade700,
          ),
        );
    }
  }

  Color _getMessageBubbleColor(ChatMessage message) {
    switch (message.sender) {
      case MessageSender.user:
        return Colors.blue.shade50; // より薄い青で読みやすく
      case MessageSender.ai:
        return Colors.grey.shade100;
      case MessageSender.instructor:
        return Colors.orange.shade50;
    }
  }

  Color _getMessageTextColor(ChatMessage message) {
    switch (message.sender) {
      case MessageSender.user:
        return Colors.blue.shade800; // ダークブルーで統一感を保つ
      case MessageSender.ai:
      case MessageSender.instructor:
        return Colors.black87;
    }
  }

  // Language detection and mapping for syntax highlighting
  String? _getLanguageForHighlighting(String language) {
    final langLower = language.toLowerCase();
    switch (langLower) {
      case 'dart':
        return dart.id;
      case 'javascript':
      case 'js':
        return javascript.id;
      case 'python':
      case 'py':
        return python.id;
      case 'json':
        return json.id;
      case 'yaml':
      case 'yml':
        return yaml.id;
      case 'sql':
        return sql.id;
      case 'xml':
      case 'html':
        return xml.id;
      case 'css':
        return css.id;
      default:
        return null; // Fallback to plain text
    }
  }

  // Build syntax highlighted code widget
  Widget _buildHighlightedCode(String code, String language) {
    final languageId = _getLanguageForHighlighting(language);

    if (languageId != null) {
      // Use syntax highlighting for supported languages with selectable text
      try {
        final result = highlight.parse(code, languageId: languageId);
        debugPrint('Parsing result nodes count: ${result.nodes?.length ?? 0}');

        if (result.nodes != null && result.nodes!.isNotEmpty) {
          final spans = _buildHighlightedSpans(result);
          debugPrint('Generated spans count: ${spans.length}');

          if (spans.isNotEmpty) {
            return SelectableText.rich(
              TextSpan(children: spans),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.4,
              ),
            );
          }
        }
      } catch (e) {
        // Highlighting error, fall back to plain text
      }
    }

    // Fallback to plain text
    return SelectableText(
      code,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.4,
        color: Colors.white,
      ),
    );
  }

  // Build highlighted TextSpan list from highlighting result
  List<TextSpan> _buildHighlightedSpans(Result result) {
    final spans = <TextSpan>[];

    if (result.nodes != null) {
      for (final node in result.nodes!) {
        _processNode(node, spans);
      }
    }

    return spans;
  }

  // Process highlighting node recursively
  void _processNode(Node node, List<TextSpan> spans, [String? inheritedClassName]) {
    final currentClassName = node.className ?? inheritedClassName;

    if (node.children.isNotEmpty) {
      // Node with children - process recursively, passing down className
      for (final child in node.children) {
        _processNode(child, spans, currentClassName);
      }
    } else if (node.value?.isNotEmpty == true) {
      // Leaf node with text - create styled span
      final style = _getStyleForClass(currentClassName);
      spans.add(TextSpan(
        text: node.value,
        style: style,
      ));
    }
  }

  // Get TextStyle for syntax highlighting class
  TextStyle _getStyleForClass(String? className) {
    if (className == null) {
      return const TextStyle(color: Colors.white);
    }

    // Define VS Code-like dark theme colors manually
    // Let's be more inclusive with className matching
    final lowerClassName = className.toLowerCase();

    if (lowerClassName.contains('keyword') || lowerClassName.contains('built_in')) {
      return const TextStyle(color: Color(0xFF569CD6)); // Blue
    } else if (lowerClassName.contains('string') || lowerClassName.contains('literal')) {
      return const TextStyle(color: Color(0xFFCE9178)); // Orange
    } else if (lowerClassName.contains('number')) {
      return const TextStyle(color: Color(0xFFB5CEA8)); // Light green
    } else if (lowerClassName.contains('comment')) {
      return const TextStyle(color: Color(0xFF6A9955)); // Green
    } else if (lowerClassName.contains('type') || lowerClassName.contains('class')) {
      return const TextStyle(color: Color(0xFF4EC9B0)); // Cyan
    } else if (lowerClassName.contains('function') || lowerClassName.contains('title')) {
      return const TextStyle(color: Color(0xFFDCDCAA)); // Light yellow
    } else if (lowerClassName.contains('variable') || lowerClassName.contains('name')) {
      return const TextStyle(color: Color(0xFF9CDCFE)); // Light blue
    } else if (lowerClassName.contains('operator')) {
      return const TextStyle(color: Colors.white);
    } else if (lowerClassName.contains('punctuation')) {
      return const TextStyle(color: Color(0xFFD4D4D4)); // Light gray
    } else if (lowerClassName.contains('subst')) {
      return const TextStyle(color: Color(0xFF9CDCFE)); // Light blue for string interpolation
    } else if (lowerClassName.contains('meta')) {
      return const TextStyle(color: Color(0xFF6A9955)); // Green for annotations like @override
    } else {
      return const TextStyle(color: Colors.white);
    }
  }
}

enum MessageSender {
  user, // 質問者（ユーザー）
  ai, // AI（Gemini）
  instructor, // 講師
}

enum MessageType {
  text, // テキストメッセージ
  image, // 画像
  video, // 動画
}

class ChatMessage {
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final String? senderId; // ユーザーID（AI以外）
  final String? senderName; // 表示名
  final String? senderAvatar; // プロフィール画像URL
  final MessageType type; // メッセージタイプ
  final String? mediaUrl; // 画像・動画のURL
  final String? fileName; // ファイル名

  ChatMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.type = MessageType.text,
    this.mediaUrl,
    this.fileName,
  });

  // 後方互換性のためのヘルパー
  bool get isUser => sender == MessageSender.user;
  bool get isAI => sender == MessageSender.ai;
  bool get isInstructor => sender == MessageSender.instructor;
  bool get hasMedia => mediaUrl != null;
  bool get isImage => type == MessageType.image;
  bool get isVideo => type == MessageType.video;
}
