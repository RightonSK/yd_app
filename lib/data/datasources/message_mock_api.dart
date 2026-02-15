import 'package:yd_app/domain/entities/message.dart';

class MessageMockApi {
  final List<Message> _messages = [
    Message(
      id: '1',
      title: '本日のキャンペーン情報',
      content: '本日よりエアコン全品10%OFFキャンペーンを開始します。お客様への案内をお願いします。',
      authorId: 'user001',
      createdAt: DateTime(2026, 2, 15, 9, 0),
    ),
    Message(
      id: '2',
      title: '新商品入荷のお知らせ',
      content: '最新モデルの4Kテレビが入荷しました。展示コーナーにて確認してください。',
      authorId: 'user002',
      createdAt: DateTime(2026, 2, 14, 14, 30),
    ),
    Message(
      id: '3',
      title: 'シフト変更について',
      content: '来週月曜日のシフトに変更があります。掲示板を確認してください。',
      authorId: 'user003',
      createdAt: DateTime(2026, 2, 13, 11, 0),
    ),
  ];

  Future<List<Message>> fetchMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_messages);
  }

  Future<void> addMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _messages.insert(0, message);
  }
}
