import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'withdraw_model.dart';

class WithdrawPage extends StatelessWidget {
  static const String route = '/withdraw';
  final PreferredSizeWidget appBar;

  const WithdrawPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WithdrawModel>(
      create: (_) => WithdrawModel()..init(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<WithdrawModel>(
            builder: (context, model, child) {
              if (model.isLoading) {
                return const LoadingPage();
              }
              if (model.subscription == null) {
                return const NotFoundPage();
              }
              final reservations = model.reservations;

              if (reservations.isNotEmpty) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'プラン予約があるため退会できません。\n退会する場合はプラン変更画面へ行き、プラン予約を解除してください',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: primaryYellowColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ));
              }

              if (model.isUnderCancelReservation) {
                // 退会予約済みの場合
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '退会予約済みです。',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: primaryYellowColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (model.cancelAt != null)
                              Text(
                                '${DateFormat('yyyy年MM月dd日HH時mm分').format(model.cancelAt!)}に全てのFirebaseデータが削除され、Githubアカウントはチームから解除されます。Slackはその後手動で解除されます。その時間まではキャンセル予約の解除が可能です。',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            const SizedBox(
                              height: 32,
                            ),
                            Center(
                              child: RoundedMoveButton(
                                isMobile: true,
                                title: '退会予約を取り消す',
                                onTap: () async {
                                  final isYes = await showConfirmDialog(
                                      context, '退会予約を取り消しますか？');
                                  if (isYes) {
                                    try {
                                      model.startLoading();
                                      await model.cancelToWithdraw(context);
                                      await showTextDialog(
                                        context,
                                        '退会予約を取り消しました',
                                      );
                                      // 反映されないのでちょっと待つ
                                      await Future.delayed(
                                        const Duration(seconds: 3),
                                      );
                                      await model.init();
                                    } catch (e) {
                                      showTextDialog(context, e.toString());
                                    } finally {
                                      model.endLoading();
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              } else {
                // これから退会する場合
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '退会すると、全てのFirebaseデータが削除され、FUT残高、バッジ、メンタープランなどのデータが全て無くなります。また、SlackやGithubアカウントはチームから解除されます。',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '退会を決める前に、何かご相談があれば右下のボタンからお問い合わせください。運営メンバーが対応いたします。',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: RoundedMoveButton(
                              isLoading: model.isLoading,
                              isMobile: true,
                              title: '退会の確認へ',
                              onTap: () async {
                                context.push(
                                  WithdrawQuestionnairePage.route,
                                  extra: model.subscription,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
