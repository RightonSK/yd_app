import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class PricePlanWidget extends StatelessWidget {
  const PricePlanWidget({
    Key? key,
    required this.isMobile,
    required this.plan,
    required this.intervalType,
    required this.amount,
    required this.trainingPlanAvailableCount,
    this.isSelected = false,
  }) : super(key: key);
  final bool isMobile;
  final Plan plan;
  final IntervalType intervalType;
  final int amount;
  final double trainingPlanAvailableCount;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final priceAMonth = plan.getPrice(IntervalType.month)!;
    final monthCount = intervalType.monthCount;
    final bool trainingPlanAvailable = trainingPlanAvailableCount > 0;
    return Container(
      height: isMobile ? 300 : 470,
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 2 : 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: isSelected ? 4 : 2,
          color: isSelected ? primaryYellowColor : Colors.white,
        ),
        color: isSelected ? Colors.white : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: isSelected ? primaryYellowColor : Colors.white,
            ),
            height: isMobile ? 33 : 64,
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        plan.icon,
                        color: isSelected
                            ? (plan.planType == PlanType.training ? Colors.red : Colors.white)
                            : primaryNavyColor,
                        size: isMobile ? 14 : 32,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        plan.nameLocalized,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: isMobile ? 6 : 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : primaryNavyColor,
                            ),
                      ),
                      if (isMobile)
                        const SizedBox(
                          width: 12,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            plan.lPDescription,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected ? primaryNavyColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 5 : 14,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          if (intervalType != IntervalType.month)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${((1 - (amount / (priceAMonth.unitAmount! * monthCount))) * 100).toInt()}%OFF',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? Colors.redAccent : primaryYellowColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 5 : 14,
                        height: 0.9,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${(plan.getPrice(IntervalType.month)!.unitAmount! * monthCount).getSplitAmount()}円',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? primaryNavyColor : Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: isMobile ? 12 : 20,
                        decoration: TextDecoration.lineThrough,
                        height: 0.9,
                      ),
                ),
              ],
            ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    amount.getSplitAmount(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? primaryNavyColor : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 18 : 44,
                          height: 0.9,
                        ),
                  ),
                  const SizedBox(width: 2),
                  Column(
                    children: [
                      SizedBox(height: isMobile ? 8 : 32),
                      Text(
                        '${t.price.yen} / ${intervalType.label}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isSelected ? primaryNavyColor : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 4 : 12,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (intervalType != IntervalType.month)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: isMobile ? 2 : 8),
                    Text(
                      t.price.if_convert_to_month,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected ? primaryNavyColor : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: isMobile ? 5 : 10,
                          ),
                    ),
                  ],
                ),
                Text(
                  (amount / monthCount).floor().getSplitAmount(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? primaryNavyColor : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 8 : 20,
                      ),
                ),
                Column(
                  children: [
                    SizedBox(height: isMobile ? 2 : 8),
                    Text(
                      t.price.yen_per_month,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected ? primaryNavyColor : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 5 : 8,
                          ),
                    ),
                  ],
                ),
                SizedBox(width: isMobile ? 8 : 16),
              ],
            ),
          const SizedBox(
            height: 8,
          ),
          _Line(isSelected: isSelected),
          Row(
            children: [
              SizedBox(
                width: isMobile ? 8 : 20,
              ),
              Expanded(
                child: Text(
                  plan.lPFeature,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? primaryNavyColor : Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: isMobile ? 8 : 13,
                        height: isMobile ? 1.5 : 1.8,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "詳しくみる",
                        style: MultiLineStyle(
                          color: isSelected ? primaryNavyColor : Colors.white,
                          fontSize: isMobile ? 7 : 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: isSelected ? primaryNavyColor : Colors.white,
                        size: isMobile ? 8 : 16,
                      ),
                    ],
                  ),
                  onTap: () async {
                    URLUtils.launch(urlString: plan.moreLinkURL);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final bool isSelected;

  const _Line({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Container(
        color: isSelected ? primaryNavyColor : Colors.white,
        height: 2,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}

class SelectablePricePlanWidget extends StatelessWidget {
  const SelectablePricePlanWidget({
    Key? key,
    required this.isMobile,
    required this.plan,
    required this.intervalType,
    this.isSelected = false,
    this.isCurrent = false,
    this.isReserved = false,
    required this.onSelectedPrice,
    required this.trainingPlanAvailableCount,
  }) : super(key: key);
  final bool isMobile;
  final Plan plan;
  final IntervalType intervalType;

  final bool isSelected;
  final bool isCurrent;
  final bool isReserved;
  final double? trainingPlanAvailableCount;

  final void Function(Price price) onSelectedPrice;

  @override
  Widget build(BuildContext context) {
    final price = plan.getPrice(intervalType);
    final trainingPlanAvailableCount = this.trainingPlanAvailableCount ?? 7;
    final bool trainingPlanAvailable = trainingPlanAvailableCount > 0;

    final planWidget = PricePlanWidget(
      isMobile: isMobile,
      plan: plan,
      isSelected: isSelected,
      amount: kIsWeb ? price!.unitAmount! : price!.nativePriceAmount,
      intervalType: intervalType,
      trainingPlanAvailableCount: trainingPlanAvailableCount,
    );

    if (isReserved) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: planWidget,
            ),
            const Text(
              '予約中',
              style: BoldMultiLineStyle(
                color: primaryYellowColor,
              ),
            ),
          ],
        ),
      );
    } else if (isCurrent) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: planWidget,
            ),
            const Text(
              '加入中',
              style: BoldMultiLineStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else if (plan.planType == PlanType.training && !trainingPlanAvailable) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: planWidget,
            ),
            const Text(
              '今月は締め切りました',
              style: BoldMultiLineStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Bounce(
          duration: const Duration(milliseconds: 110),
          child: planWidget,
          onPressed: () {
            if (isCurrent) {
              return;
            }
            onSelectedPrice(price);
          },
        ),
      );
    }
  }
}
