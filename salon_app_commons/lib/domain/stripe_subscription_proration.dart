import 'package:salon_app_commons/utils/date_utils.dart';

class StripeSubscriptionProration {
  final int amount;
  final String description;
  final DateTime start;
  final DateTime end;
  final int discountAmount;

  StripeSubscriptionProration._(
    this.amount,
    this.description,
    this.start,
    this.end,
    this.discountAmount,
  );

  factory StripeSubscriptionProration.json(Map data) {
    return StripeSubscriptionProration._(
      data['amount'] ?? 0,
      data['description'] ?? '',
      unixSecondsToDateTime(data['period']['start']),
      unixSecondsToDateTime(data['period']['end']),
      _toDiscountAmount(data['discount_amounts']),
    );
  }

  static int _toDiscountAmount(List? discountAmounts) {
    if (discountAmounts == null) {
      return 0;
    }

    if (discountAmounts.isEmpty) {
      return 0;
    }
    return discountAmounts[0]['amount'] ?? 0;
  }
}
