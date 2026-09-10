import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class SentVerificationModel extends ChangeNotifier {
  bool isVerifiedLoading = false;
  bool isResendLoading = false;

  void startVerifiedLoading() {
    isVerifiedLoading = true;
    notifyListeners();
  }

  void endVerifiedLoading() {
    isVerifiedLoading = false;
    notifyListeners();
  }

  void startResendLoading() {
    isResendLoading = true;
    notifyListeners();
  }

  void endResendLoading() {
    isResendLoading = false;
    notifyListeners();
  }

  Future checkIsEmailVerified(BuildContext context) async {
    await FirebaseAuth.instance.currentUser!.reload();
    final emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    logger.d('emailVerified:$emailVerified');
    if (emailVerified) {
      // もう認証済みだったらプラン選択画面へ遷移する
      context.go(SelectPlanPage.route);
      await AnalyticsUtils.sendLog(AnalyticsEvent.btnVerifyEmail);
    } else {
      throw ('''認証が完了しておりません。\nメール内の認証URLをタップしてメールアドレス認証を完了してください
      ''');
    }
  }

  /// メールアドレス認証メールの再送信
  Future sendVerification() async {
    await UserRepository().sendVerification();
  }
}
