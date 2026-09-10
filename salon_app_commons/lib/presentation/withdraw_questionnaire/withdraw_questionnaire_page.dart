import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class WithdrawQuestionnairePage extends StatelessWidget {
  static const String route = '/withdraw_confirm';
  final PreferredSizeWidget appBar;
  final AbstractSubscription? subscription;

  const WithdrawQuestionnairePage({
    Key? key,
    required this.appBar,
    required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WithdrawQuestionnaireModel>(
      create: (_) => WithdrawQuestionnaireModel(subscription)..init(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<WithdrawQuestionnaireModel>(
            builder: (context, model, child) {
              if (model.isLoading) {
                return const LoadingPage();
              }
              if (model.subscription == null) {
                return const NotFoundPage();
              }

              final subscription = model.subscription;

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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (subscription is StripeSubscription &&
                                subscription.currentPeriodEnd != null)
                              Text(
                                '現在のプランの期間が終わる日付に退会が予約されます。\n予約後も${DateFormat('yyyy年MM月dd日HH時mm分').format(subscription.currentPeriodEnd!)}までは退会予約を取り消すことが可能です。',
                                style: const MultiLineStyle(
                                  color: Colors.white,
                                ),
                              ),
                            if (subscription is RevenueCatSubscription)
                              const Text(
                                'モバイルアプリから入会した場合、サブスクリプションの解除はスマホの設定画面から行ってください。退会とはまた別です。',
                                style: MultiLineStyle(color: Colors.white),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        DropdownButtonFormField<WithdrawReason>(
                          isExpanded: true,
                          hint: const Text('今後の改善のため退会理由をお聞かせください🙏'),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: WithdrawReason.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ),
                              )
                              .toList(),
                          onChanged: (WithdrawReason? value) {
                            model.setReason(value);
                          },
                          value: model.withdrawReason,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        if (model.withdrawReason == WithdrawReason.other)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: CommonTextFormField(
                              hintText: 'その他の理由を教えてください',
                              controller: model.otherReasonController,
                            ),
                          ),
                        Center(
                          child: RoundedMoveButton(
                            isLoading: model.isLoading,
                            isMobile: true,
                            title: (subscription is StripeSubscription)
                                ? '退会を予約する'
                                : '今すぐ退会する',
                            onTap: model.canSubmit
                                ? () async {
                                    final isYes = await showConfirmDialog(
                                        context, '本当に退会しますか？');
                                    if (isYes) {
                                      try {
                                        model.startLoading();

                                        await model.withdraw(context);

                                        if (subscription
                                            is StripeSubscription) {
                                          await showTextDialog(
                                            context,
                                            '退会を予約しました',
                                          );
                                        } else {
                                          await showTextDialog(
                                            context,
                                            '退会しました',
                                          );
                                        }
                                        // 反映されないのでちょっと待つ
                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                        context.go(WithdrawPage.route);
                                      } catch (e) {
                                        showErrorDialogAndInquiryChat(
                                            context, e);
                                      } finally {
                                        model.endLoading();
                                      }
                                    }
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 80, // お問い合わせボタンとかぶるので下の幅は広めにとる
                        ),
                      ],
                    ),
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
