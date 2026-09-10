import 'package:salon_app_commons/domain/stripe_subscription_schedule_phase.dart';
import 'package:salon_app_commons/utils/date_utils.dart';

class StripeSubscriptionSchedule {
  final String id;
  final DateTime created;
  final String status;
  final bool scheduled;
  final String endBehavior;
  final List<StripeSubscriptionSchedulePhase> phases;

  StripeSubscriptionSchedule._(
    this.id,
    this.created,
    this.status,
    this.scheduled,
    this.endBehavior,
    this.phases,
  );

  factory StripeSubscriptionSchedule.json(Map data) {
    final phasesData = data['phases'] as List;
    final phases = phasesData
        .map((data) => StripeSubscriptionSchedulePhase.json(data))
        .toList();
    return StripeSubscriptionSchedule._(
      data['id'] ?? 0,
      unixSecondsToDateTime(data['created']),
      data['status'] ?? '',
      data['scheduled'] ?? false,
      data['end_behavior'] ?? '',
      phases,
    );
  }

}
