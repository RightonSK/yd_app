import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// 決済完了ページ
class ThanksPage extends StatelessWidget {
  static const String route = '/thanks';

  final PreferredSizeWidget appBar;

  const ThanksPage({Key? key, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThanksModel>(
      create: (_) => ThanksModel()..init(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<ThanksModel>(
            builder: (context, model, child) {
              if (model.isLoading) {
                return const LoadingPage();
              }
              final subscription = model.subscription;

              if (subscription == null) {
                return const NotFoundPage();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          '以下のプランへの入会が完了しました🎉',
                          style: BoldMultiLineStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PlanCard(
                          isMobile: isMobile,
                          imageUrl: subscription.planType.imageURLForNative,
                          name: subscription.planType.displayName,
                          description:
                              subscription.planType.descriptionForNative,
                          priceText: '${subscription.amount.getSplitAmount()}円',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        subscription.isErrorStatus
                            ? const SizedBox()
                            : _paidMemberWidget(context, model),
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

  Widget _paidMemberWidget(BuildContext context, ThanksModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Text(
          '引き続き、次ページからニックネーム登録、Slack、Githubアカウント連携を行います。',
          style: MultiLineStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: RoundedMoveButton(
            isMobile: true,
            title: '初期設定へ進む',
            onTap: () async {
              context.push(
                '${NicknameInputPage.route}?plan=${model.subscription?.planType.displayName}',
              );
              await AnalyticsUtils.sendLog(AnalyticsEvent.btnGoToTutorial);
            },
          ),
        ),
      ],
    );
  }
}
