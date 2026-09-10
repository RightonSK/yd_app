import 'package:salon_app_commons/domain/plan_type.dart';

import 'abstract_subscription.dart';

class RevenueCatSubscription implements AbstractSubscription {
  final String? id;
  final String? autoResumeDate;
  final String? billingIssuesDetectedAt;
  final String? expiresDate;
  final String? gracePeriodExpiresDate;
  final bool? isSandbox;
  final String? originalPurchaseDate;
  final String? ownershipType;
  final String? periodType;
  final String? purchaseDate;
  final String? refundedAt;
  final String? store;
  final String? unsubscribeDetectedAt;

  RevenueCatSubscription._({
    required this.id,
    required this.autoResumeDate,
    required this.billingIssuesDetectedAt,
    required this.expiresDate,
    required this.gracePeriodExpiresDate,
    required this.isSandbox,
    required this.originalPurchaseDate,
    required this.ownershipType,
    required this.periodType,
    required this.purchaseDate,
    required this.refundedAt,
    required this.store,
    required this.unsubscribeDetectedAt,
  });

  factory RevenueCatSubscription.json(String id, Map data) {
    return RevenueCatSubscription._(
      id: id,
      autoResumeDate: data['auto_resume_date'],
      billingIssuesDetectedAt: data['billing_issues_detected_at'],
      expiresDate: data['expires_date'],
      gracePeriodExpiresDate: data['grace_period_expires_date'],
      isSandbox: data['is_sandbox'],
      originalPurchaseDate: data['original_purchase_date'],
      ownershipType: data['ownership_type'],
      periodType: data['period_type'],
      purchaseDate: data['purchase_date'],
      refundedAt: data['refunded_at'],
      store: data['store'],
      unsubscribeDetectedAt: data['unsubscribe_detected_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auto_resume_date': autoResumeDate,
      'billing_issues_detected_at': billingIssuesDetectedAt,
      'expires_date': expiresDate,
      'grace_period_expires_date': gracePeriodExpiresDate,
      'is_sandbox': isSandbox,
      'original_purchase_date': originalPurchaseDate,
      'ownership_type': ownershipType,
      'period_type': periodType,
      'purchase_date': purchaseDate,
      'refunded_at': refundedAt,
      'store': store,
      'unsubscribe_detected_at': unsubscribeDetectedAt,
    };
  }

  @override
  int get amount => PlanType.fromRevenueCatId(id).nativeAmount;

  @override
  DateTime? get created => originalPurchaseDate != null
      ? DateTime.parse(originalPurchaseDate!)
      : DateTime.now();

  @override
  DateTime? get expired =>
      expiresDate != null ? DateTime.parse(expiresDate!) : DateTime.now();

  @override
  bool get isErrorStatus => false;

  @override
  PlanType get planType => PlanType.fromRevenueCatId(id);

  @override
  DateTime? get currentPeriodStart =>
      purchaseDate != null ? DateTime.parse(purchaseDate!) : null;
}
