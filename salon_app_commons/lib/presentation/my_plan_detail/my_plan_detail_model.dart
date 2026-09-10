import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyPlanDetailModel extends ChangeNotifier {
  AbstractSubscription? subscription;
  List<StripeSubscriptionSchedule>? reservations;
  MyPlanDetailModel(this.subscription, this.reservations);

  /// 入会日時からの経過月を返す
  String getElapsed() {
    if (subscription == null) {
      return '不明';
    }
    final diff = DateTime.now().difference(subscription!.created!);
    final diffDtime = DateTime.fromMillisecondsSinceEpoch(diff.inMilliseconds);
    final diffYear = diffDtime.year - 1970;
    final diffMonth = diffDtime.month;
    return diffYear > 0 ? '$diffYear年$diffMonthヶ月目' : '$diffMonthヶ月目';
  }
}
