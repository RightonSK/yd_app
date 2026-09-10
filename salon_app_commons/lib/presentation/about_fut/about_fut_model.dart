import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:salon_app_commons/domain/fut_reasons.dart';
import 'package:salon_app_commons/repository/fut_transaction_repository.dart';
import 'package:salon_app_commons/repository/user_repository.dart';
import 'package:salon_app_commons/utils/dialog_utils.dart';
import 'package:salon_app_commons/utils/log_utils.dart';

class AboutFutModel extends ChangeNotifier {
  bool isLoading = false;

  final _futRepo = FUTTransactionRepository();
  final _userRepo = UserRepository();

  //広告
  RewardedAd? rewardedAd;
  final adCompleter = Completer<RewardedAd?>();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //広告を読み込む
  Future<void> _createRewardedAd() async {
    await RewardedAd.load(
        adUnitId:
            kDebugMode ? getTestAdRewardedUnitId() : getAdRewardedUnitId(),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            logger.d('$ad ロード完了.');
            //広告の中身取得
            adCompleter.complete(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.d('ロード失敗: $error');
            adCompleter.complete(null);
          },
        ));
  }

  Future<void> showRewardedAd(context) async {
    //広告読み込み
    //ここを待ってくれず、そのままL57の処理が行われてnull判定される。
    await _createRewardedAd();

    rewardedAd = await adCompleter.future;

    if (rewardedAd == null) {
      logger.d('Warning: reward広告が読み込まれる前に表示しようとしている.');
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          logger.d('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        //広告表示後に広告を閉じた時
        ad.dispose();
        showTextDialog(context, "${FUTReasons.viewAd.futAmount}FUTをゲットしました");
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        logger.d('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // _createRewardedAd();
      },
    );
    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      await getRewardAdFUT();
    });
    rewardedAd = null;
  }

  /// 広告を見た方にfutを付与する
  Future<void> getRewardAdFUT() async {
    final futAmount = FUTReasons.viewAd.futAmount ?? 1;
    await _futRepo.addObtainTransaction(
      uid: FirebaseAuth.instance.currentUser!.uid,
      coinAmount: futAmount,
      reason: FUTReasons.viewAd,
    );
    await _userRepo.incrementUserFUT(futAmount);
  }

  //テスト用のidを返す
  String getTestAdRewardedUnitId() {
    final String testRewardUnitId;
    if (Platform.isAndroid) {
      // Android のとき
      testRewardUnitId = "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      // iOSのとき
      testRewardUnitId = "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw Exception('このプラットフォームには対応していません');
    }
    return testRewardUnitId;
  }

  String getAdRewardedUnitId() {
    final String rewardUnitId;
    if (Platform.isAndroid) {
      // Android のとき
      rewardUnitId = "ca-app-pub-6455174264595723/9289904372";
    } else if (Platform.isIOS) {
      // iOSのとき
      rewardUnitId = "ca-app-pub-6455174264595723/9275508227";
    } else {
      throw Exception('このプラットフォームには対応していません');
    }
    return rewardUnitId;
  }
}
