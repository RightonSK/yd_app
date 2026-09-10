import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'purchase_history_page.dart';
import 'teacher_model.dart';

class TeacherPage extends StatelessWidget {
  static const String route = '/teacher';
  final PreferredSizeWidget? appBar;

  const TeacherPage({
    Key? key,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeacherModel>(
      create: (_) => TeacherModel()..init(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<TeacherModel>(
            builder: (context, model, child) {
              final user = model.user;

              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              final purchaseHistories = model.purchaseHistories;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          '現在のステータス',
                          style: MultiLineStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.detailsSubmitted ? '本人確認済み' : '本人確認できていません',
                              style: const BoldMultiLineStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            if (user.detailsSubmitted)
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 32,
                              )
                          ],
                        ),
                        if (!user.detailsSubmitted)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              '※本人確認後もステータスが更新されない場合、画面のリロードをお試しください',
                              style: MultiLineStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 32,
                        ),
                        RoundedMoveButton(
                          width: 330,
                          isMobile: true,
                          isLoading: model.isLoading,
                          iconData: Icons.verified_outlined,
                          title: user.detailsSubmitted ? '講師管理画面' : '本人確認して講師になる',
                          onTap: () async {
                            try {
                              final accountId = user.stripeAccountId;

                              if (user.detailsSubmitted && accountId != null) {
                                model.startLoading();
                                await model.redirectToStripeExpress(accountId);
                                return;
                              }

                              // Check if user already has an incomplete account
                              if (accountId != null && accountId.isNotEmpty && !user.detailsSubmitted) {
                                final isYes =
                                    await showConfirmDialog(context, '本人確認を完了させていない講師アカウントがあります。本人確認を続行しますか？');
                                if (isYes) {
                                  model.startLoading();
                                  await model.redirectToStripeAccountLink();
                                }
                                return;
                              }

                              final isYes = await showConfirmDialog(context, '必要情報を入力して、講師になりますか？');

                              if (isYes) {
                                model.startLoading();
                                await model.redirectToStripeAccountLink();
                              }
                            } catch (e) {
                              await showErrorDialogAndInquiryChat(context, e.toString());
                            } finally {
                              await Future.delayed(const Duration(seconds: 2));
                              model.endLoading();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (user.detailsSubmitted)
                          RoundedMoveButton(
                            width: 330,
                            isMobile: true,
                            iconData: Icons.preview,
                            title: 'プレビュー',
                            onTap: () async {
                              context.go('/users/${user.id}');
                            },
                          ),
                        const SizedBox(
                          height: 48,
                        ),
                        IntrinsicWidth(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: primaryYellowColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'プラン販売した場合の手数料',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                child: const Tooltip(
                                  message: '手数料計算の詳しいロジックはこちら',
                                  child: Icon(
                                    Icons.help,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                ),
                                onTap: () {
                                  URLUtils.launch(
                                      urlString: 'https://github.com/flutteruniv/docs/blob/master/codeboy2.md');
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: model.references.isNotEmpty
                              ? CommissionGauge(
                                  rate: model.commissionRate,
                                  references: model.references,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryNavyColor,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 48),
                        IntrinsicWidth(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                color: primaryYellowColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'メンタープラン取引履歴',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (purchaseHistories != null)
                          (purchaseHistories.isNotEmpty
                              ? Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 400),
                                      child: ListView.builder(
                                        itemCount: purchaseHistories.length > 5 ? 5 : purchaseHistories.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final history = purchaseHistories[index];
                                          return PurchaseHistoryListTile(
                                            history: history,
                                          );
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        child: const Text(
                                          '取引履歴をもっとみる',
                                          style: TextStyle(color: primaryYellowColor),
                                        ),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PurchaseHistoryPage(
                                                histories: purchaseHistories,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  '取引履歴はありません',
                                  style: MultiLineStyle(color: Colors.white),
                                ))
                        else
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        const SizedBox(
                          height: 80,
                        ), // お問い合わせボタンとかぶるので下の幅は広めにとる
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

class CommissionGauge extends StatelessWidget {
  const CommissionGauge({
    super.key,
    required this.rate,
    required this.references,
  });

  final TeacherCommissionRate rate;
  final List<TeacherCommissionReference> references;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 270,
          endAngle: 570,
          interval: (references.last.requiredAmount / references.length).floor().toDouble(),
          showFirstLabel: true,
          minimum: 0,
          maximum: references.last.requiredAmount,
          labelsPosition: ElementsPosition.outside,
          showLabels: true,
          showAxisLine: true,
          labelOffset: 17,
          labelFormat: '{value}\nFUT',
          axisLineStyle: const AxisLineStyle(
            thickness: 10,
            cornerStyle: CornerStyle.bothCurve,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              enableAnimation: true,
              value: rate.totalAmount.toDouble(),
              cornerStyle: CornerStyle.bothCurve,
              color: primaryNavyColor,
            ),
          ],
          annotations: <GaugeAnnotation>[
            ...references.map((ref) {
              final angleLevel =
                  ref.requiredAmount == 0 ? 0 : (300 * (ref.requiredAmount / references.last.requiredAmount));
              return GaugeAnnotation(
                widget: Text(
                  '${ref.commissionRate * 100}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                positionFactor: 0.65,
                angle: (270 + angleLevel).toDouble(),
              );
            }).toList(),
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '手数料',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${rate.commissionRate * 100}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(${rate.totalAmount.toInt().getSplitAmount()} FUT)',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '※直近3ヶ月間の集計',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              angle: 90,
              positionFactor: 0.05,
            ),
          ],
        ),
      ],
    );
  }
}
