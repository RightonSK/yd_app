import 'package:flutter/material.dart';
import 'package:salon_app_commons/repository/functions_repository.dart';
import 'package:salon_app_commons/repository/fut_transaction_repository.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

import '../../domain/fut_reasons.dart';

class SlackTimesInputModel extends ChangeNotifier {
  bool isLoading = false;
  bool? slackTimesIdExists;

  final _futRepo = FUTTransactionRepository();
  final _userRepo = UserRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future fetchUserAndCheckTimesId() async {
    final user = await _userRepo.fetchMyUser();
    slackTimesIdExists = user?.slackTimesId != null;
    notifyListeners();
  }

  /// timesチャンネルが存在するかチェック
  Future checkIsThereTimesAndGetFUT(String timesName) async {
    // チャンネルを検証
    final channelId = await _validate(timesName);
    // チャンネルIDをfirebaseに登録
    await UserRepository().updateSlackTimesChannelId(channelId);
    // futを付与
    await _futRepo.addObtainTransaction(
      uid: FirebaseAuth.instance.currentUser!.uid,
      coinAmount: 50,
      reason: FUTReasons.madeSlackTimes,
    );
    await _userRepo.incrementUserFUT(50);
  }

  /// チャンネル名が有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  Future<String> _validate(String timesName) async {
    if (timesName.isEmpty) {
      throw ('slackチャンネル名を入力してください');
    }

    if (!timesName.startsWith('times_')) {
      throw ('times_〇〇の形式で入力してください');
    }

    final channelId = await FunctionsRepository().searchSlackTimes(timesName);
    return channelId;
  }
}
