import '../utils/log_utils.dart';
import 'stripe_subscription_proration.dart';

class StripeUpcomingInvoice {
  final int total;
  final List<StripeSubscriptionProration> prorations;

  StripeUpcomingInvoice._(
    this.total,
    this.prorations,
  );

  factory StripeUpcomingInvoice.json(Map data) {
    final total = data['total'] ?? 0;
    final lines = data['lines']['data'] as List;
    final prorations =
        lines.map((data) => StripeSubscriptionProration.json(data)).toList();
    logger.d('----');
    logger.d('total:$total');
    logger.d(lines.length);
    logger.d(lines);
    return StripeUpcomingInvoice._(
      total,
      prorations,
    );
  }
}
