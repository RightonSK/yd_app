import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class ZennInputModel extends ChangeNotifier {
  bool isLoading = false;

  final textController = TextEditingController(text: '');

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateZennId(String zennId) async {
    final validated = await _validate(zennId);
    await UserRepository().updateZennId(validated);
  }

  /// チャンネル名が有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  Future<String> _validate(String zennId) async {
    if (zennId.isEmpty) {
      throw ('Zennユーザー名を入力してください');
    }

    if (zennId == 'kboy') {
      throw ('ご自身のZennユーザー名を入力してください');
    }
    return zennId;
  }
}
