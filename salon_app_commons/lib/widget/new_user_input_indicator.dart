import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class NewUserInputIndicator extends StatelessWidget {
  const NewUserInputIndicator(this.number, {Key? key}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: LinearPercentIndicator(
              percent: number / 7,
              animation: false,
              animationDuration: 1500,
              progressColor: primaryYellowColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            '$number / 7 ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
