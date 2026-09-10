import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// 決済完了ページ
class MemberThanksPage extends StatelessWidget {
  static const String route = '/users_thanks';

  final PreferredSizeWidget appBar;
  final String? slackId;
  final String? title;
  final String? priceText;

  const MemberThanksPage({
    Key? key,
    required this.appBar,
    required this.slackId,
    required this.title,
    required this.priceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Builder(
        builder: (context) {
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
                      'プランへの決済が完了しました🎉',
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
                      imageUrl: null,
                      name: title ?? 'タイトルエラー',
                      description: '',
                      priceText: priceText ?? '金額エラー',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'slackにて日程調整をしましょう！',
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
                            title: 'Slackへ飛ぶ',
                            onTap: () async {
                              final slackTimesUrl =
                                  'slack://channel?team=T012UQWDRQC&id=$slackId';
                              await URLUtils.launch(
                                urlString: slackTimesUrl,
                                shouldOpenNewTab: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
