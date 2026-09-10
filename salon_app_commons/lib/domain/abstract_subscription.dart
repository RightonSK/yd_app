import 'package:salon_app_commons/domain/plan_type.dart';

abstract class AbstractSubscription {
  bool get isErrorStatus;
  int get amount;
  PlanType get planType;
  DateTime? get created;
  DateTime? get expired;
  DateTime? get currentPeriodStart;
}
