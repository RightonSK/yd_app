import 'package:cloud_firestore/cloud_firestore.dart';

import 'interval_type.dart';
import 'plan_type.dart';

/// プラン料金
class Price {
  final String? id;
  final bool? active;
  final String? currency;
  final String? description;
  final String? interval;
  final int? intervalCount;
  final int? trialPeriodDays;
  final String? type;
  final int? unitAmount;

  Price._(
    this.id,
    this.active,
    this.currency,
    this.description,
    this.interval,
    this.intervalCount,
    this.trialPeriodDays,
    this.type,
    this.unitAmount,
  );

  factory Price.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return Price._(
      doc.id,
      data['active'],
      data['currency'],
      data['description'],
      data['interval'],
      data['interval_count'],
      data['trial_period_days'],
      data['type'],
      data['unit_amount'],
    );
  }

  /// 年額|月額|週額|日額を返す
  IntervalType? get intervalType {
    switch (interval) {
      case 'month':
        switch (intervalCount) {
          case 1:
            return IntervalType.month;
          case 3:
            return IntervalType.threeMonth;
          case 6:
            return IntervalType.sixMonth;
        }
        return null;
      case 'year':
        return IntervalType.year;
    }
    return null;
  }

  /// 値段からプランを算出する
  /// 値段が変わったらワークしないのであまり信用できない
  PlanType get _planType {
    switch (intervalType) {
      case IntervalType.month:
        switch (unitAmount) {
          case 0:
            return PlanType.free;
          case 1100:
          case 2200:
            return PlanType.community;
          case 3300:
          case 4400:
            return PlanType.learning;
          case 9900:
            return PlanType.trainingLight;
          default:
            return PlanType.training;
        }
      case IntervalType.threeMonth:
        switch (unitAmount) {
          case 0:
            return PlanType.free;
          case 4950:
            return PlanType.community;
          case 9900:
            return PlanType.learning;
          case 24750:
            return PlanType.trainingLight;
          default:
            return PlanType.training;
        }
      case IntervalType.sixMonth:
        switch (unitAmount) {
          case 0:
            return PlanType.free;
          case 7700:
            return PlanType.community;
          case 15400:
            return PlanType.learning;
          case 44550:
            return PlanType.trainingLight;
          default:
            return PlanType.training;
        }
      case IntervalType.year:
        switch (unitAmount) {
          case 0:
            return PlanType.free;
          case 11000:
            return PlanType.community;
          case 22000:
            return PlanType.learning;
          case 69300:
            return PlanType.trainingLight;
          default:
            return PlanType.training;
        }
      default:
        return PlanType.free;
    }
  }

  int get nativePriceAmount {
    switch (_planType) {
      case PlanType.community:
        return 3000;
      case PlanType.learning:
        return 6000;
      case PlanType.trainingLight:
        return 12000;
      case PlanType.training:
        return 15400;
      default:
        return 0;
    }
  }
}
