import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// 認証メール送信完了ページ
class SentVerificationPage extends StatelessWidget {
  static const String route = '/sentVerification';

  final PreferredSizeWidget appBar;

  const SentVerificationPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SentVerificationModel>(
      create: (_) => SentVerificationModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<SentVerificationModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        '認証メールを送信しました。',
                        style: MultiLineStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'メール内のURLをタップした後、下記の「認証したので次へ進む」ボタンを押してください。',
                        style: MultiLineStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      RoundedMoveButton(
                        isMobile: true,
                        title: '認証したので次へ進む',
                        isLoading: model.isVerifiedLoading,
                        onTap: () async {
                          model.startVerifiedLoading();

                          try {
                            await model.checkIsEmailVerified(context);
                          } catch (e) {
                            showTextDialog(context, e.toString());
                          } finally {
                            model.endVerifiedLoading();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        '※迷惑メール等に分類されている場合があるので「すべてのメール」をご確認ください。',
                        style: MultiLineStyle(
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '※10分以上認証メールが届かないなどの不備があれば、下記の「認証メールの再送信」をお試し下さい。',
                        style: MultiLineStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          model.startResendLoading();
                          try {
                            await model.sendVerification();
                            showTextDialog(context, '認証メールを再送信しました！');
                          } catch (e) {
                            showTextDialog(context, e.toString());
                          } finally {
                            model.endResendLoading();
                          }
                        },
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Center(
                            child: Stack(
                              children: [
                                Text(
                                  '認証メールを再送信する',
                                  style: MultiLineStyle(
                                    color: model.isResendLoading ? primaryNavyColor : primaryYellowColor,
                                  ),
                                ),
                                if (model.isResendLoading)
                                  const Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: primaryYellowColor,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
