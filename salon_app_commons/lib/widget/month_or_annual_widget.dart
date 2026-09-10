import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class IntervalTypeWidget extends StatelessWidget {
  const IntervalTypeWidget({
    Key? key,
    required this.selectedIntervalType,
    required this.onSelectedIntervalType,
  }) : super(key: key);

  final IntervalType selectedIntervalType;
  final void Function(IntervalType intervalType) onSelectedIntervalType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 72,
          child: RoundedActionButton(
            isMobile: false,
            title: t.interval.monthly,
            textColor: selectedIntervalType == IntervalType.month
                ? Colors.white
                : primaryNavyColor,
            backgroundColor: selectedIntervalType == IntervalType.month
                ? primaryYellowColor
                : Colors.white.withOpacity(0.7),
            onTap: () {
              onSelectedIntervalType(IntervalType.month);
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          width: 72,
          child: RoundedActionButton(
            isMobile: false,
            title: t.interval.threeMonth,
            textColor: selectedIntervalType == IntervalType.threeMonth
                ? Colors.white
                : primaryNavyColor,
            backgroundColor: selectedIntervalType == IntervalType.threeMonth
                ? primaryYellowColor
                : Colors.white.withOpacity(0.7),
            onTap: () {
              onSelectedIntervalType(IntervalType.threeMonth);
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          width: 72,
          child: RoundedActionButton(
            isMobile: false,
            title: t.interval.sixMonth,
            textColor: selectedIntervalType == IntervalType.sixMonth
                ? Colors.white
                : primaryNavyColor,
            backgroundColor: selectedIntervalType == IntervalType.sixMonth
                ? primaryYellowColor
                : Colors.white.withOpacity(0.7),
            onTap: () {
              onSelectedIntervalType(IntervalType.sixMonth);
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          width: 72,
          child: RoundedActionButton(
            isMobile: false,
            title: t.interval.annual,
            textColor: selectedIntervalType == IntervalType.year
                ? Colors.white
                : primaryNavyColor,
            backgroundColor: selectedIntervalType == IntervalType.year
                ? primaryYellowColor
                : Colors.white.withOpacity(0.7),
            onTap: () {
              onSelectedIntervalType(IntervalType.year);
            },
          ),
        ),
      ],
    );
  }
}
