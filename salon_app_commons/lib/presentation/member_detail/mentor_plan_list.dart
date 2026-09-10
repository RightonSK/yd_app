import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MentorPlanList extends StatelessWidget {
  const MentorPlanList({
    Key? key,
    required this.user,
    required this.myUid,
    required this.mentorPlans,
  }) : super(key: key);

  final User user;
  final String? myUid;
  final List<MentorPlan> mentorPlans;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                children: [
                  if (myUid != user.id) ...[
                    const SizedBox(height: 16),
                    RoundedMoveButton(
                      isMobile: true,
                      title: 'Slackで相談・リクエスト',
                      onTap: () async {
                        final isYes = await showConfirmDialog(
                          context,
                          'slackにてプランの購入を相談してみましょう！\n\n※slackアプリがインストールされている場合のみslackが起動します。',
                        );
                        if (isYes) {
                          // slackのurlスキームを試みる
                          final slackTimesUrl = 'slack://channel?team=T012UQWDRQC&id=${user.slackTimesId}';
                          await URLUtils.launch(
                            urlString: slackTimesUrl,
                            shouldOpenNewTab: false,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  mentorPlans.isNotEmpty
                      ? Column(
                          children: mentorPlans.map((plan) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _MentorPlanCell(mentorPlan: plan),
                            );
                          }).toList(),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'メンタープランがありません。',
                            textAlign: TextAlign.center,
                            style: MultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  if (myUid == user.id)
                    RoundedMoveButton(
                      isMobile: true,
                      iconData: Icons.preview,
                      title: 'プランを追加する',
                      onTap: () async {
                        if (user.detailsSubmitted) {
                          context.push(MentorPlanUpsertingPage.route);
                        } else {
                          final isYes = await showConfirmDialog(
                            context,
                            'メンタープランの作成には本人確認が必要です。\n講師ページにて本人確認しますか？',
                          );

                          if (isYes) {
                            context.go(TeacherPage.route);
                          }
                        }
                      },
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorPlanCell extends StatelessWidget {
  final MentorPlan mentorPlan;

  const _MentorPlanCell({
    required this.mentorPlan,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MemberDetailModel>();
    final bool isArchived = mentorPlan.isArchived;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        child: InkWell(
          onTap: model.myUid != model.user?.id
              ? () async {
                  // プラン購入へ
                  int? result;

                  if (mentorPlan.futAmount == 0) {
                    final isYes = await showConfirmDialog(context, '「${mentorPlan.title}」を購入しますか？');
                    if (isYes) {
                      result = 1;
                    }
                  } else {
                    result = await showThreeOptionDialog(
                      context,
                      message: '「${mentorPlan.title}」を購入しますか？',
                      actionText1: '円で購入',
                      actionText2: 'FUTで購入',
                      negativeText: 'キャンセル',
                      barrierDismissible: true,
                    );
                  }

                  final commonRoute =
                      '${MemberThanksPage.route}?slack_id=${model.user?.slackId}&title=${mentorPlan.title}';

                  switch (result) {
                    case 1:
                      model.startLoading();

                      try {
                        final baseURL = URLUtils.getBaseUrl();
                        final succeedUrl =
                            Uri.encodeFull('$baseURL$commonRoute&priceText=${mentorPlan.price.getSplitAmount()}円');
                        logger.d(succeedUrl);
                        await model.buyPlan(mentorPlan, succeedUrl);
                      } catch (e) {
                        logger.d(e.toString());
                        await showErrorDialogAndInquiryChat(context, e);
                      }
                      break;
                    case 2:
                      if (model.purchaserFUTAmount! < mentorPlan.futAmount) {
                        await showTextDialog(
                          context,
                          'FUTが足りないため、購入できません。',
                        );
                        break;
                      } else {
                        // FUTの増減、プランのステータス変更、購入履歴の追加、メール送信、Slack通知をonCreateで行う。
                        await model.requestFUTTransaction(mentorPlan);
                        final route = '$commonRoute&priceText=${mentorPlan.futAmount.getSplitAmount()}FUT';
                        context.go(route);
                        break;
                      }
                    default:
                      break;
                  }
                }
              : null,
          child: Card(
            color: isArchived ? Colors.grey : Colors.white,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryNavyColor,
                                width: 4,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Center(
                              child: SelectableText(
                                '単発',
                                textAlign: TextAlign.center,
                                style: BoldMultiLineStyle(
                                  color: primaryNavyColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                      Expanded(
                        child: Text(
                          mentorPlan.title,
                          style: const BoldMultiLineStyle(fontSize: 24),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      model.myUid != model.user?.id
                          ? const SizedBox.shrink()
                          : PopupMenuButton(
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  textStyle: TextStyle(color: Colors.black),
                                  value: 'edit',
                                  child: Text('編集'),
                                ),
                                PopupMenuItem(
                                  textStyle: const TextStyle(color: Colors.black),
                                  value: 'archive',
                                  child: isArchived ? const Text('アーカイブ解除') : const Text('アーカイブ'),
                                ),
                                PopupMenuItem(
                                  textStyle: TextStyle(
                                    color: mentorPlan.isPurchased ? Colors.grey : Colors.red,
                                  ),
                                  value: mentorPlan.isPurchased ? 'Purchased' : 'delete',
                                  child: const Text('削除'),
                                ),
                              ],
                              onSelected: (menu) async {
                                switch (menu) {
                                  case 'edit':
                                    context.push("${MentorPlanUpsertingPage.route}?plan_id=${mentorPlan.id}");
                                    break;
                                  case 'archive':
                                    final isYes = await showConfirmDialog(
                                        context,
                                        isArchived
                                            ? '本当に「${mentorPlan.title}」のアーカイブを解除しますか？'
                                            : '本当に「${mentorPlan.title}」をアーカイブしますか？');
                                    if (isYes) {
                                      await model.changeArchiveStatus(mentorPlan);
                                      await showTextDialog(
                                          context, isArchived ? 'プランのアーカイブを解除しました。' : 'プランをアーカイブしました。');

                                      // 再リロード
                                      model.init();
                                    }
                                    break;
                                  case 'Purchased':
                                    //購入者あり削除不可
                                    await showTextDialog(
                                      context,
                                      '「${mentorPlan.title}」は既に購入されているため、削除できません。',
                                    );
                                    break;
                                  case 'delete':
                                    final isYes = await showConfirmDialog(
                                      context,
                                      '本当に「${mentorPlan.title}」を削除しますか？',
                                    );
                                    if (isYes) {
                                      final isPurchased = await model.checkPurchaseStatus(mentorPlan);

                                      if (isPurchased) {
                                        await showTextDialog(
                                          context,
                                          '「${mentorPlan.title}」は既に購入されているため、削除できません。',
                                        );
                                      } else {
                                        //購入者なし削除可
                                        try {
                                          await model.deleteMentorPlan(mentorPlan);
                                          await showTextDialog(
                                            context,
                                            'プランを削除しました。',
                                          );
                                          // 再リロード
                                          model.init();
                                        } catch (e) {
                                          showErrorDialogAndInquiryChat(
                                            context,
                                            e,
                                          );
                                        }
                                      }
                                    }
                                    break;
                                }
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        mentorPlan.description,
                        style: const MultiLineStyle(),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 30,
                    ),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${mentorPlan.price.getSplitAmount()}円',
                            style: const BoldMultiLineStyle(),
                          ),
                          const SizedBox(width: 6),
                          if (mentorPlan.futAmount > 0) ...[
                            const Text(
                              'or',
                              style: BoldMultiLineStyle(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${mentorPlan.futAmount.getSplitAmount()}FUT',
                              style: const BoldMultiLineStyle(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
