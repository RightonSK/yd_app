import 'package:salon_app_commons/domain/stripe_subscription_item.dart';
import 'package:salon_app_commons/utils/date_utils.dart';

class StripeSubscriptionSchedulePhase {
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<StripeSubscriptionItem> items;

  StripeSubscriptionSchedulePhase._(
    this.description,
    this.startDate,
    this.endDate,
    this.items,
  );

  factory StripeSubscriptionSchedulePhase.json(Map data) {
    final itemsData = data['items'] as List;
    final items =
        itemsData.map((data) => StripeSubscriptionItem.json(data)).toList();
    return StripeSubscriptionSchedulePhase._(
      data['description'] ?? '',
      unixSecondsToDateTime(data['start_date']),
      unixSecondsToDateTime(data['end_date']),
      items,
    );
  }

}
