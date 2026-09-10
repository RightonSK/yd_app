import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.onTappedGitHubButton,
    required this.onTappedAdmissionButton,
  }) : super(key: key);
  final void Function() onTappedGitHubButton;
  final void Function() onTappedAdmissionButton;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LPModel>();
    final isMobile = model.isMobile;
    final plans = model.plans;
    final trainingPlanAvailableCount = model.trainingPlanAvailableCount ?? 7;

    return LPBaseContainer(
      isMobile: isMobile,
      padding: isMobile
          ? const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            )
          : null,
      bodyMaxWidth: 900,
      color: primaryNavyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMobile)
            const SizedBox(
              height: 40,
            ),
          Text(
            'Price',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: isMobile ? 42 : 156,
                  color: Colors.white,
                  height: 1,
                ),
          ),
          Text(
            '料金プラン',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 32,
          ),
          IntervalTypeWidget(
            selectedIntervalType: model.selectedIntervalType,
            onSelectedIntervalType: ((intervalType) {
              model.selectInterval(intervalType);
            }),
          ),
          const SizedBox(
            height: 16,
          ),
          if (plans != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plans.map((plan) {
                final price = plan.getPrice(model.selectedIntervalType);
                return Expanded(
                  child: PricePlanWidget(
                    isMobile: isMobile,
                    plan: plan,
                    isSelected: false,
                    intervalType: model.selectedIntervalType,
                    amount:
                        kIsWeb ? price!.unitAmount! : price!.nativePriceAmount,
                    trainingPlanAvailableCount: trainingPlanAvailableCount,
                  ),
                );
              }).toList(),
            ),
          const SizedBox(
            height: 64,
          ),
          CTAButton(
            onTappedGitHubButton: onTappedGitHubButton,
            onTappedAdmissionButton: onTappedAdmissionButton,
          ),
          SizedBox(
            height: isMobile ? 80 : 128,
          ),
        ],
      ),
    );
  }
}
