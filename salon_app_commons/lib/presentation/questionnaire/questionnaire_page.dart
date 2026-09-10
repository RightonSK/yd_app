import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class QuestionnairePage extends StatelessWidget {
  static const String route = '/questionnaire';
  final PreferredSizeWidget appBar;
  final void Function(BuildContext context) onTapNextPage;

  const QuestionnairePage({
    Key? key,
    required this.appBar,
    required this.onTapNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionnaireModel>(
      create: (_) => QuestionnaireModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<QuestionnaireModel>(builder: (context, model, child) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    const NewUserInputIndicator(7),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      '新入会の方へアンケートをお願いしております。\nFlutter大学の今後の発展にご協力お願いします！',
                      style: MultiLineStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '①ITエンジニア経験',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<EngineerAttribute>(
                            isExpanded: true,
                            hint: const Text('選択してください'),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: EngineerAttribute.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.label,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (EngineerAttribute? value) {
                              model.setEngineerAttribute(value);
                            },
                            value: model.engineerAttribute,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '②Flutter経験（趣味か実務かは問いません）',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<FlutterExperience>(
                            isExpanded: true,
                            hint: const Text('選択してください'),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: FlutterExperience.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.label,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (FlutterExperience? value) {
                              model.setFlutterExperience(value);
                            },
                            value: model.flutterExperience,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '③Flutter大学を知ったきっかけ',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<TriggerToKnow>(
                            isExpanded: true,
                            hint: const Text('選択してください'),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: TriggerToKnow.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.label,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (TriggerToKnow? value) {
                              model.setTriggerToKnow(value);
                            },
                            value: model.triggerToKnow,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '④Flutter大学に入った目的',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<Purpose>(
                            isExpanded: true,
                            hint: const Text('選択してください'),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: Purpose.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.label,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (Purpose? value) {
                              model.setPurpose(value);
                            },
                            value: model.purpose,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '⑤現在の転職意欲・求職状況',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<JobSeekingStatus>(
                            isExpanded: true,
                            hint: const Text('選択してください'),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: JobSeekingStatus.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.label,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (JobSeekingStatus? value) {
                              model.setJobSeekingStatus(value);
                            },
                            value: model.jobSeekingStatus,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            '⑥その他メッセージ',
                            style: MultiLineStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          CommonTextFormField(
                            hintText: 'その他何か運営に伝えたいことがあればお願いします！',
                            controller: model.otherCommentController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RoundedMoveButton(
                      isMobile: true,
                      isLoading: model.isLoading,
                      title: '回答してマイページへ',
                      onTap: model.canSubmit
                          ? () async {
                              model.startLoading();
                              try {
                                await model.sendQuestionnaire();

                                // おすすめ記事を出す
                                await _showRecommendedArticle(context);

                                onTapNextPage(context);

                                AnalyticsUtils.sendLog(
                                  AnalyticsEvent.btnGoToMyPage,
                                );
                              } catch (e) {
                                showErrorDialogAndInquiryChat(context, e);
                              } finally {
                                model.endLoading();
                              }
                            }
                          : null,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future _showRecommendedArticle(BuildContext context) async {
    final model = context.read<QuestionnaireModel>();

    // 記事の確認
    String recommendArticleImagePath;
    String recommendArticleURL;

    if (model.purpose == Purpose.wantToBecomeEngineerFromScratch ||
        model.engineerAttribute == EngineerAttribute.newToEngineering) {
      // 未経験向けロードマップ
      recommendArticleImagePath =
          'salon_app_commons/resources/ogp-flutter-roadmap.png';
      recommendArticleURL =
          'https://zenn.dev/flutteruniv_dev/articles/flutter-roadmap';
    } else {
      // 中上級者向け
      recommendArticleImagePath =
          'salon_app_commons/resources/ogp-how-to-use-1.png';
      recommendArticleURL =
          'https://zenn.dev/flutteruniv_dev/articles/how-to-use-1';
    }

    final isYes = await showActionConfirmDialog(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'あなたにおすすめの記事',
            style: BoldMultiLineStyle(),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'あなたの回答結果から、おすすめのFlutter大学の使い方の記事を紹介します。',
            style: MultiLineStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Card(
            child: Image.asset(
              recommendArticleImagePath,
            ),
          ),
        ],
      ),
      '見る',
      'またあとで',
    );

    if (isYes) {
      await URLUtils.launch(
        urlString: recommendArticleURL,
      );
    }
  }
}
