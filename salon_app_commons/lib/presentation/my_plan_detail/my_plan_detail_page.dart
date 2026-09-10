import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'my_plan_detail_model.dart';

class MyPlanDetailPage extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final AbstractSubscription? subscription;
  final List<StripeSubscriptionSchedule>? reservations;

  const MyPlanDetailPage({
    super.key,
    required this.appBar,
    this.subscription,
    this.reservations,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPlanDetailModel>(
      create: (_) => MyPlanDetailModel(subscription, reservations),
      child: Consumer<MyPlanDetailModel>(
        builder: (context, model, child) {
          final isStripeSubscription = subscription is StripeSubscription;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            body: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: isStripeSubscription
                    ? const StripePlanDetailBody()
                    : const RevenueCatPlanDetailBody(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StripePlanDetailBody extends StatelessWidget {
  const StripePlanDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MyPlanDetailModel>();
    final subscription = model.subscription as StripeSubscription?;
    final reservations = model.reservations;

    if (subscription == null) {
      return const FlutterUnivLoadingIndicator();
    }

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // FIXME:
              //if (subscription.isErrorStatus) PaymentErrorWidget(),
              Column(
                children: [
                  ListTile(
                    title: const Text('決済の状態'),
                    subtitle: Row(
                      children: [
                        const Spacer(),
                        Text(subscription.displayStatus),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.black45,
                  ),
                ],
              ),
              ListTile(
                title: const Text('現在のプラン'),
                subtitle: Row(
                  children: [
                    Expanded(child: Text(subscription.currentPlan.name!)),
                    const Spacer(),
                    Text(
                      '¥${subscription.currentPrice.unitAmount?.getSplitAmount()}',
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              // 予約プランがある場合
              if (reservations != null && reservations.isNotEmpty)
                Column(
                  children: [
                    ListTile(
                      title: const Text('予約中のプラン'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(reservations.first.phases.first.description),
                            ],
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                "(${DateFormat('yyyy年MM月dd日 HH時mm分').format(subscription.currentPeriodEnd!)}から適用)",
                                style: const TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                  ],
                ),
              ListTile(
                title: const Text('次回決済'),
                subtitle: Row(
                  children: [
                    Text(DateFormat('yyyy年MM月dd日 HH時mm分')
                        .format(subscription.currentPeriodEnd!)),
                    const Spacer(),
                    if (reservations == null) // 予約の方の金額が取れないので
                      Text(
                        "¥${subscription.currentPrice.unitAmount!.getSplitAmount()}"),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              ListTile(
                title: const Text('入会日時'),
                subtitle: Row(
                  children: [
                    Text(DateFormat('yyyy年MM月dd日 HH時mm分')
                        .format(subscription.created!)),
                    const Spacer(),
                    Text(model.getElapsed()),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RevenueCatPlanDetailBody extends StatelessWidget {
  const RevenueCatPlanDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MyPlanDetailModel>();
    final subscription = model.subscription as RevenueCatSubscription?;

    if (subscription == null) {
      return const FlutterUnivLoadingIndicator();
    }

    return Column(
      children: [
        ListTile(
          title: Text(subscription.planType.displayName),
          subtitle: Row(
            children: [
              Expanded(
                  child: Text('更新日：${subscription.expired?.formatYMDWHM}')),
              Text(subscription.amount.getSplitAmount()),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('サブスクの解除方法'),
          onTap: () {
            // commonsのfirebaseConfigを使う
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              URLUtils.launch(
                  urlString: 'https://support.apple.com/ja-jp/HT202039');
            } else {
              URLUtils.launch(
                  urlString:
                      'https://support.google.com/googleplay/answer/7018481');
            }
          },
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        const Divider(),
      ],
    );
  }
}
