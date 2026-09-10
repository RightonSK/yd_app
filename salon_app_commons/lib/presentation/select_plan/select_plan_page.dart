import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// プランの変更
class SelectPlanPage extends StatelessWidget {
  static const String route = '/select_plan';

  final PreferredSizeWidget appBar;
  final Future Function(BuildContext context)? initForInAppPurchase;
  final void Function(BuildContext context)? restoreForInAppPurchase;
  final Future Function(BuildContext context, String? customerId, Price price)
      onSelected;

  const SelectPlanPage({
    Key? key,
    required this.appBar,
    required this.initForInAppPurchase,
    required this.restoreForInAppPurchase,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectPlanModel>(
      create: (_) => SelectPlanModel()..init(context, initForInAppPurchase),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: ResponsiveBuilder(builder: (context, sizingInformation) {
            final isMobile = checkIsMobile(sizingInformation);
            return Consumer<SelectPlanModel>(
              builder: (context, model, child) {
                // プランの行を生成する
                final plans = model.plans;
                final selectedIntervalType = model.selectedIntervalType;

                if (plans == null) {
                  return const LoadingPage();
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '入会したいプランを選択し、下部の「決済へ進む」ボタンを押してください。',
                          style: MultiLineStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // webしか年額とかを出さない
                        if (kIsWeb)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: IntervalTypeWidget(
                              selectedIntervalType: selectedIntervalType,
                              onSelectedIntervalType: (intervalType) {
                                model.selectInterval(intervalType);
                              },
                            ),
                          ),
                        SizedBox(
                          width: 900,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: plans.map((plan) {
                              final price = plan.getPrice(selectedIntervalType);
                              return SelectablePricePlanWidget(
                                  isMobile: isMobile,
                                  plan: plan,
                                  intervalType: selectedIntervalType,
                                  isSelected: model.selectedPrice == price,
                                  trainingPlanAvailableCount:
                                      model.trainingPlanAvailableCount,
                                  onSelectedPrice: (price) {
                                    model.select(price);
                                  });
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: Consumer<SelectPlanModel>(
                              builder: (context, model, child) {
                            return RoundedMoveButton(
                              isMobile: true,
                              isLoading: model.isLoading,
                              title: "決済へ進む",
                              onTap: () async {
                                final price = model.selectedPrice;

                                if (price == null) {
                                  await showErrorDialogAndInquiryChat(
                                    context,
                                    '料金情報が取得できません',
                                  );
                                  return;
                                }

                                logger.d(price.id);
                                logger.d(price.unitAmount);

                                await onSelected(
                                  context,
                                  model.user?.stripeId,
                                  price,
                                );
                              },
                            );
                          }),
                        ),
                        if (restoreForInAppPurchase != null)
                          const SizedBox(
                            height: 16,
                          ),
                        if (restoreForInAppPurchase != null)
                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: primaryYellowColor,
                              ),
                              onPressed: () {
                                restoreForInAppPurchase!(context);
                              },
                              child: const Text(
                                '購入を復元する',
                                style: MultiLineStyle(
                                  fontSize: 14,
                                  color: primaryYellowColor,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 64,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
